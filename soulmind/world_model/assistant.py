"""Reasoning assistant that coordinates structured world model updates."""
from __future__ import annotations

import asyncio
import logging
import random
from dataclasses import dataclass
from pathlib import Path
from time import monotonic
from typing import Any, Iterable, Mapping, Optional, Protocol, Sequence

try:  # pragma: no cover - optional dependency for configuration loading
    import yaml
except Exception:  # pragma: no cover - fallback if PyYAML unavailable
    yaml = None  # type: ignore

from pydantic import ValidationError

from ..perception.llm_client import LLMClient
from . import reasoning_prompts, state_serialization
from .schemas import CounterExample, Hypothesis, OntologySuggestion, Proposal, ReasoningBundle
from .validators import ProposalValidationResult, ProposalValidator, run_validators

logger = logging.getLogger(__name__)


class WorldModelAPI(Protocol):
    """Protocol describing the required world model interface."""

    async def get_snapshot(self) -> Mapping[str, Any]:
        ...

    async def update_state(self, proposals: Sequence[Mapping[str, Any]]) -> None:
        ...


@dataclass
class LoadControlSettings:
    max_concurrent_cycles: int = 1
    min_interval_seconds: float = 60.0
    load_average_threshold: float = 0.75


@dataclass
class SchedulerSettings:
    interval_seconds: float = 300.0
    jitter_seconds: float = 30.0


@dataclass
class TokenSettings:
    summary_tokens: int = 512


@dataclass
class WorldModelConfig:
    """Configuration for reasoning cadence and throttling."""

    load_control: LoadControlSettings
    scheduler: SchedulerSettings
    token_limits: TokenSettings

    @classmethod
    def from_mapping(cls, mapping: Mapping[str, Any]) -> "WorldModelConfig":
        load_ctrl = LoadControlSettings(**mapping.get("load_control", {}))
        scheduler = SchedulerSettings(**mapping.get("scheduler", {}))
        token_limits = TokenSettings(**mapping.get("token_limits", {}))
        return cls(load_control=load_ctrl, scheduler=scheduler, token_limits=token_limits)

    @classmethod
    def from_file(cls, path: str | Path) -> "WorldModelConfig":
        with open(path, "r", encoding="utf-8") as handle:
            if yaml is not None:
                raw = yaml.safe_load(handle)
            else:  # pragma: no cover - fallback if PyYAML is missing
                import json

                raw = json.loads(handle.read())
        if not isinstance(raw, Mapping):
            raise ValueError("world model configuration must be a mapping")
        return cls.from_mapping(raw)


class WorldModelReasoningAssistant:
    """Coordinates reasoning prompts, validation, and state updates."""

    def __init__(
        self,
        world_model: WorldModelAPI,
        llm_client: LLMClient,
        config: WorldModelConfig,
        *,
        validators: Optional[Iterable[ProposalValidator]] = None,
    ) -> None:
        self._world_model = world_model
        self._llm_client = llm_client
        self._config = config
        self._validators = list(validators or [])
        self._cycle_semaphore = asyncio.Semaphore(max(1, config.load_control.max_concurrent_cycles))
        self._last_cycle_at: float | None = None
        self._scheduler_task: asyncio.Task[None] | None = None
        self._stop_event: asyncio.Event | None = None

    async def start(self) -> None:
        if self._scheduler_task is not None:
            return
        self._stop_event = asyncio.Event()
        self._scheduler_task = asyncio.create_task(self._scheduler_loop())

    async def stop(self) -> None:
        if self._scheduler_task is None or self._stop_event is None:
            return
        self._stop_event.set()
        await self._scheduler_task
        self._scheduler_task = None
        self._stop_event = None

    async def _scheduler_loop(self) -> None:
        assert self._stop_event is not None
        while not self._stop_event.is_set():
            try:
                await self.run_reasoning_cycle()
            except Exception:  # pragma: no cover - defensive logging
                logger.exception("World model reasoning cycle failed")
            delay = self._config.scheduler.interval_seconds
            if self._config.scheduler.jitter_seconds:
                delay += random.uniform(0, self._config.scheduler.jitter_seconds)
            try:
                await asyncio.wait_for(self._stop_event.wait(), timeout=delay)
            except asyncio.TimeoutError:
                continue

    async def run_reasoning_cycle(self) -> None:
        """Execute a single reasoning iteration if throttling permits."""

        if self._last_cycle_at is not None:
            elapsed = monotonic() - self._last_cycle_at
            if elapsed < self._config.load_control.min_interval_seconds:
                logger.debug("Skipping reasoning cycle: respecting min interval")
                return

        async with self._cycle_semaphore:
            snapshot = await self._world_model.get_snapshot()
            metrics = snapshot.get("metrics", {})
            load_average = float(metrics.get("load_average", 0.0) or 0.0)
            if load_average >= self._config.load_control.load_average_threshold:
                logger.info(
                    "Skipping reasoning cycle due to elevated load: %.2f >= %.2f",
                    load_average,
                    self._config.load_control.load_average_threshold,
                )
                return

            summary = state_serialization.summarise_graph_state(
                snapshot.get("nodes", []),
                snapshot.get("edges", []),
                metrics,
                max_tokens=self._config.token_limits.summary_tokens,
            )

            bundle = await self._gather_proposals(summary)
            accepted: list[Proposal] = []
            rejected: list[tuple[Proposal, ProposalValidationResult]] = []
            for proposal in bundle:
                result = await run_validators(proposal, snapshot, self._validators)
                if result.accepted:
                    accepted.append(proposal)
                else:
                    rejected.append((proposal, result))

            for proposal, result in rejected:
                logger.info(
                    "Rejected %s: %s",
                    proposal.type,
                    result.reason or "no reason provided",
                )

            if not accepted:
                return

            payload = [proposal.model_dump() for proposal in accepted]
            await self._world_model.update_state(payload)
            self._last_cycle_at = monotonic()

    async def _gather_proposals(self, summary: str) -> ReasoningBundle:
        prompts = {
            "hypotheses": reasoning_prompts.hypothesis_generation(summary),
            "ontology": reasoning_prompts.ontology_enrichment(summary),
            "counter": reasoning_prompts.counterfactual_scenarios(summary),
        }

        bundle = ReasoningBundle()
        try:
            hypotheses_raw = await self._llm_client.generate_structured(prompts["hypotheses"])
            bundle.hypotheses = self._parse_hypotheses(hypotheses_raw)
        except (ValidationError, ValueError) as exc:
            logger.warning("Hypothesis parsing failed: %s", exc)
        try:
            ontology_raw = await self._llm_client.generate_structured(prompts["ontology"])
            bundle.ontology = self._parse_ontology(ontology_raw)
        except (ValidationError, ValueError) as exc:
            logger.warning("Ontology parsing failed: %s", exc)
        try:
            counter_raw = await self._llm_client.generate_structured(prompts["counter"])
            bundle.counter_examples = self._parse_counterexamples(counter_raw)
        except (ValidationError, ValueError) as exc:
            logger.warning("Counterexample parsing failed: %s", exc)
        return bundle

    def _parse_hypotheses(self, payload: Mapping[str, Any]) -> list[Hypothesis]:
        raw = payload.get("hypotheses", [])
        if not isinstance(raw, Sequence):
            raise ValueError("'hypotheses' must be a list")
        return [Hypothesis.model_validate(item) for item in raw]

    def _parse_ontology(self, payload: Mapping[str, Any]) -> list[OntologySuggestion]:
        raw = payload.get("ontology_suggestions", [])
        if not isinstance(raw, Sequence):
            raise ValueError("'ontology_suggestions' must be a list")
        return [OntologySuggestion.model_validate(item) for item in raw]

    def _parse_counterexamples(self, payload: Mapping[str, Any]) -> list[CounterExample]:
        raw = payload.get("counter_examples", [])
        if not isinstance(raw, Sequence):
            raise ValueError("'counter_examples' must be a list")
        return [CounterExample.model_validate(item) for item in raw]


__all__ = ["WorldModelReasoningAssistant", "WorldModelConfig", "LoadControlSettings", "SchedulerSettings", "TokenSettings"]

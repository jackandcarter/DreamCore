"""Batching perception ingestor that orchestrates prompt building and parsing."""
from __future__ import annotations

import asyncio
from collections.abc import Mapping as MappingABC, Sequence as SequenceABC
from dataclasses import dataclass
from pathlib import Path
from time import monotonic
from typing import Any, List, Mapping, Optional, Sequence

try:  # pragma: no cover - optional dependency for configuration loading
    import yaml
except Exception:  # pragma: no cover - fallback if PyYAML is unavailable
    yaml = None  # type: ignore

from pydantic import ValidationError

from . import prompt_templates
from .llm_client import LLMClient
from .schemas import ConceptEdge, ConceptNode, Observation


@dataclass
class LLMSettings:
    base_url: str
    model: str
    max_tokens: int = 1024
    temperature: float = 0.2
    rate_limit_per_minute: int = 60


@dataclass
class BatchingSettings:
    max_batch_size: int = 4
    max_latency_ms: int = 250
    estimated_observation_cost_mb: int = 64

    @property
    def max_latency_seconds(self) -> float:
        return self.max_latency_ms / 1000.0


@dataclass
class ResourceCaps:
    ram_cap_mb: int = 4096
    gpu_cap_mb: int = 2048


@dataclass
class PerceptionConfig:
    llm: LLMSettings
    batching: BatchingSettings
    resources: ResourceCaps

    @property
    def effective_batch_size(self) -> int:
        caps = [self.resources.ram_cap_mb, self.resources.gpu_cap_mb]
        estimated = self.batching.estimated_observation_cost_mb or 1
        viable = [cap // estimated for cap in caps if cap]
        resource_limited = min(viable) if viable else self.batching.max_batch_size
        return max(1, min(self.batching.max_batch_size, max(1, resource_limited)))

    @classmethod
    def from_mapping(cls, mapping: Mapping[str, Any]) -> "PerceptionConfig":
        llm_cfg = mapping.get("llm", {})
        batching_cfg = mapping.get("batching", {})
        resource_cfg = mapping.get("resources", {})
        llm = LLMSettings(**llm_cfg)
        batching = BatchingSettings(**batching_cfg)
        resources = ResourceCaps(**resource_cfg)
        return cls(llm=llm, batching=batching, resources=resources)

    @classmethod
    def from_file(cls, path: str | Path) -> "PerceptionConfig":
        raw: Mapping[str, Any]
        with open(path, "r", encoding="utf-8") as handle:
            if yaml is not None:
                raw = yaml.safe_load(handle)
            else:  # pragma: no cover - fallback in environments without PyYAML
                import json

                raw = json.loads(handle.read())
        if not isinstance(raw, MappingABC):
            raise ValueError("perception configuration must be a mapping")
        return cls.from_mapping(raw)


@dataclass
class PerceptionResult:
    observation: Observation
    nodes: List[ConceptNode]
    edges: List[ConceptEdge]
    uncertainty: float


class PerceptionIngestor:
    """Coordinate observation batching and LLM backed schema extraction."""

    def __init__(
        self,
        llm_client: LLMClient,
        config: PerceptionConfig,
    ) -> None:
        self._llm_client = llm_client
        self._config = config
        self._queue: "asyncio.Queue[Optional[tuple[Observation, asyncio.Future[PerceptionResult]]]]" = (
            asyncio.Queue()
        )
        self._worker: Optional[asyncio.Task[None]] = None

    async def __aenter__(self) -> "PerceptionIngestor":
        await self.start()
        return self

    async def __aexit__(self, exc_type, exc, tb) -> None:
        await self.stop()

    async def start(self) -> None:
        if self._worker is None:
            self._worker = asyncio.create_task(self._batch_loop())

    async def stop(self) -> None:
        if self._worker is not None:
            await self._queue.put(None)
            await self._worker
            self._worker = None

    async def ingest(self, raw_observation: Mapping[str, Any]) -> PerceptionResult:
        observation = Observation.model_validate(raw_observation)
        future: "asyncio.Future[PerceptionResult]" = asyncio.get_running_loop().create_future()
        await self._queue.put((observation, future))
        return await future

    async def _batch_loop(self) -> None:
        while True:
            item = await self._queue.get()
            if item is None:
                self._queue.task_done()
                break
            first_observation, first_future = item
            batch_obs = [first_observation]
            batch_futures = [first_future]
            start_time = monotonic()
            stop_requested = False
            while len(batch_obs) < self._config.effective_batch_size:
                remaining = self._config.batching.max_latency_seconds - (monotonic() - start_time)
                if remaining <= 0:
                    break
                try:
                    next_item = await asyncio.wait_for(self._queue.get(), timeout=remaining)
                except asyncio.TimeoutError:
                    break
                if next_item is None:
                    self._queue.task_done()
                    stop_requested = True
                    break
                observation, fut = next_item
                batch_obs.append(observation)
                batch_futures.append(fut)
            try:
                results = await self._process_batch(batch_obs)
            except Exception as exc:  # pragma: no cover - defensive
                for future in batch_futures:
                    if not future.done():
                        future.set_exception(exc)
            else:
                results_by_id = {result.observation.observation_id: result for result in results}
                for obs, future in zip(batch_obs, batch_futures):
                    result = results_by_id.get(obs.observation_id)
                    if result is None:
                        future.set_exception(
                            RuntimeError(f"Missing result for observation {obs.observation_id}")
                        )
                    else:
                        future.set_result(result)
            finally:
                for _ in batch_obs:
                    self._queue.task_done()
            if stop_requested:
                break

    async def _process_batch(self, observations: Sequence[Observation]) -> List[PerceptionResult]:
        prompt = prompt_templates.render_observation_to_concepts(observations)
        response = await self._llm_client.generate_structured(prompt)
        try:
            return self._parse_response(response, observations)
        except (ValidationError, ValueError) as exc:
            gap_prompt = prompt_templates.render_gap_filling(
                observations, response, validation_error=str(exc)
            )
            gap_response = await self._llm_client.generate_structured(gap_prompt)
            return self._parse_response(gap_response, observations)

    def _parse_response(
        self, response: Mapping[str, Any], observations: Sequence[Observation]
    ) -> List[PerceptionResult]:
        if "results" not in response or not isinstance(response["results"], SequenceABC):
            raise ValueError("LLM response must contain a 'results' list")
        observation_index = {obs.observation_id: obs for obs in observations}
        results: List[PerceptionResult] = []
        for entry in response["results"]:
            if not isinstance(entry, MappingABC):
                raise ValueError("Each result must be a mapping")
            observation_id = entry.get("observation_id")
            if observation_id not in observation_index:
                raise ValueError(f"Unknown observation_id '{observation_id}' in response")
            nodes_payload = entry.get("nodes", [])
            edges_payload = entry.get("edges", [])
            uncertainty = float(entry.get("uncertainty", 0.5))
            nodes = [ConceptNode.model_validate(node) for node in nodes_payload]
            edges = [ConceptEdge.model_validate(edge) for edge in edges_payload]
            results.append(
                PerceptionResult(
                    observation=observation_index[observation_id],
                    nodes=nodes,
                    edges=edges,
                    uncertainty=uncertainty,
                )
            )
        ordered: List[PerceptionResult] = []
        results_by_id = {res.observation.observation_id: res for res in results}
        for obs in observations:
            match = results_by_id.get(obs.observation_id)
            if match is None:
                raise ValueError(f"Missing response entry for observation {obs.observation_id}")
            ordered.append(match)
        return ordered


__all__ = [
    "LLMSettings",
    "BatchingSettings",
    "ResourceCaps",
    "PerceptionConfig",
    "PerceptionResult",
    "PerceptionIngestor",
]

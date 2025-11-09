"""Validation primitives for world model reasoning proposals."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Awaitable, Callable, Iterable, Mapping, Optional, Protocol

from pydantic import BaseModel

from .schemas import Proposal


class ProposalValidationResult(BaseModel):
    """Outcome of a proposal validation step."""

    accepted: bool
    reason: Optional[str] = None


class ProposalValidator(Protocol):
    """Protocol for pluggable proposal validators."""

    async def validate(
        self, proposal: Proposal, snapshot: Mapping[str, object]
    ) -> ProposalValidationResult:
        ...


@dataclass
class RuleBasedValidator:
    """Validator that evaluates synchronous rule predicates."""

    rules: Iterable[Callable[[Proposal, Mapping[str, object]], bool]]
    rejection_reason: str = "Rule-based validation failed"

    async def validate(
        self, proposal: Proposal, snapshot: Mapping[str, object]
    ) -> ProposalValidationResult:
        for rule in self.rules:
            try:
                if not rule(proposal, snapshot):
                    return ProposalValidationResult(
                        accepted=False, reason=self.rejection_reason
                    )
            except Exception as exc:  # pragma: no cover - defensive
                return ProposalValidationResult(
                    accepted=False,
                    reason=f"Rule execution error: {exc}",
                )
        return ProposalValidationResult(accepted=True)


@dataclass
class SimulationValidator:
    """Validator that leverages asynchronous simulation oracles."""

    simulator: Callable[[Proposal, Mapping[str, object]], Awaitable[bool]]
    failure_reason: str = "Simulation predicted failure"

    async def validate(
        self, proposal: Proposal, snapshot: Mapping[str, object]
    ) -> ProposalValidationResult:
        result = await self.simulator(proposal, snapshot)
        return ProposalValidationResult(accepted=bool(result), reason=None if result else self.failure_reason)


@dataclass
class CompositeValidator:
    """Compose several validators sequentially."""

    validators: Iterable[ProposalValidator]

    async def validate(
        self, proposal: Proposal, snapshot: Mapping[str, object]
    ) -> ProposalValidationResult:
        for validator in self.validators:
            result = await validator.validate(proposal, snapshot)
            if not result.accepted:
                return result
        return ProposalValidationResult(accepted=True)


async def run_validators(
    proposal: Proposal,
    snapshot: Mapping[str, object],
    validators: Iterable[ProposalValidator],
) -> ProposalValidationResult:
    """Execute validators concurrently when possible and aggregate decisions."""

    validators = list(validators)
    if not validators:
        return ProposalValidationResult(accepted=True)

    # run sequentially but allow validators to run concurrently if desired by implementing
    # their own parallelism. This preserves deterministic ordering while ensuring that
    # early rejections short-circuit.
    for validator in validators:
        result = await validator.validate(proposal, snapshot)
        if not result.accepted:
            return result
    return ProposalValidationResult(accepted=True)


__all__ = [
    "ProposalValidationResult",
    "ProposalValidator",
    "RuleBasedValidator",
    "SimulationValidator",
    "CompositeValidator",
    "run_validators",
]

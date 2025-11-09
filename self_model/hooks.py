"""Event hooks emitted by the self-model when plans change state."""
from __future__ import annotations

import asyncio
from dataclasses import dataclass, field
from typing import Any, Awaitable, Callable, Dict, List, Literal, Mapping, MutableMapping, Optional

from soulmind.explanation.renderer import StructuredRationale

PlanEventName = Literal["plan_selected", "plan_completed"]


@dataclass
class RationalePayload:
    """Payload emitted alongside plan lifecycle events."""

    event: PlanEventName
    plan_id: str
    rationale: StructuredRationale
    metadata: MutableMapping[str, Any] = field(default_factory=dict)

    def to_record(self) -> Mapping[str, Any]:
        return {
            "event": self.event,
            "plan_id": self.plan_id,
            "rationale": self.rationale.to_payload(),
            "metadata": dict(self.metadata),
        }


Callback = Callable[[RationalePayload], Awaitable[None] | None]


class RationaleHooks:
    """Simple dispatcher for self-model rationale events."""

    def __init__(self) -> None:
        self._listeners: Dict[PlanEventName, List[Callback]] = {
            "plan_selected": [],
            "plan_completed": [],
        }
        self._lock = asyncio.Lock()

    def register(self, event: PlanEventName, callback: Optional[Callback] = None):
        if event not in self._listeners:
            raise ValueError(f"Unsupported event type: {event}")

        if callback is None:

            def decorator(func: Callback) -> Callback:
                self._listeners[event].append(func)
                return func

            return decorator

        self._listeners[event].append(callback)
        return callback

    async def _notify(self, payload: RationalePayload) -> None:
        async with self._lock:
            listeners = list(self._listeners.get(payload.event, []))
        tasks: List[Awaitable[None]] = []
        for callback in listeners:
            result = callback(payload)
            if asyncio.iscoroutine(result):
                tasks.append(asyncio.create_task(result))
        if tasks:
            await asyncio.gather(*tasks)

    async def emit(self, payload: RationalePayload) -> None:
        await self._notify(payload)

    async def plan_selected(
        self,
        plan_id: str,
        rationale: StructuredRationale,
        *,
        metadata: Optional[Mapping[str, Any]] = None,
    ) -> None:
        await self.emit(
            RationalePayload(
                event="plan_selected",
                plan_id=plan_id,
                rationale=rationale,
                metadata=dict(metadata or {}),
            )
        )

    async def plan_completed(
        self,
        plan_id: str,
        rationale: StructuredRationale,
        *,
        metadata: Optional[Mapping[str, Any]] = None,
    ) -> None:
        await self.emit(
            RationalePayload(
                event="plan_completed",
                plan_id=plan_id,
                rationale=rationale,
                metadata=dict(metadata or {}),
            )
        )


hooks = RationaleHooks()

__all__ = ["RationaleHooks", "RationalePayload", "hooks", "PlanEventName"]

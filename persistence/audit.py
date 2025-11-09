"""Audit trail persistence for explanation artefacts."""
from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Callable, List, Mapping, MutableMapping, Optional

from sqlalchemy import JSON, DateTime, Integer, String, Text
from sqlalchemy.orm import DeclarativeBase, Mapped, Session, mapped_column


def _utcnow() -> datetime:
    return datetime.now(timezone.utc)


class Base(DeclarativeBase):
    """Declarative base for DreamCore persistence models."""


class AuditTrailEntry(Base):
    """Record representing a rendered explanation."""

    __tablename__ = "audit_trail"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=_utcnow)
    kind: Mapped[str] = mapped_column(String(64), nullable=False)
    event: Mapped[str] = mapped_column(String(32), nullable=False)
    plan_id: Mapped[str] = mapped_column(String(128), nullable=False)
    structured_input: Mapped[MutableMapping[str, Any]] = mapped_column(JSON, nullable=False)
    generated_text: Mapped[str] = mapped_column(Text, nullable=False)
    response_payload: Mapped[MutableMapping[str, Any]] = mapped_column(JSON, default=dict)
    context_metadata: Mapped[MutableMapping[str, Any]] = mapped_column(JSON, default=dict)

    def to_dict(self) -> MutableMapping[str, Any]:
        return {
            "id": self.id,
            "created_at": self.created_at.isoformat(),
            "kind": self.kind,
            "event": self.event,
            "plan_id": self.plan_id,
            "structured_input": self.structured_input,
            "generated_text": self.generated_text,
            "response_payload": self.response_payload,
            "metadata": self.context_metadata,
        }


@dataclass
class _QueuedAuditRecord:
    kind: str
    event: str
    plan_id: str
    structured_input: Mapping[str, Any]
    generated_text: str
    response_payload: Mapping[str, Any]
    metadata: Mapping[str, Any]


class AuditTrailWriter:
    """Batch writer ensuring audit trail inserts are amortised."""

    def __init__(
        self,
        session_factory: Callable[[], Session],
        *,
        batch_size: int = 20,
    ) -> None:
        if batch_size < 1:
            raise ValueError("batch_size must be at least 1")
        self._session_factory = session_factory
        self._batch_size = batch_size
        self._buffer: List[_QueuedAuditRecord] = []

    def enqueue(
        self,
        *,
        kind: str,
        event: str,
        plan_id: str,
        structured_input: Mapping[str, Any],
        generated_text: str,
        response_payload: Optional[Mapping[str, Any]] = None,
        metadata: Optional[Mapping[str, Any]] = None,
    ) -> None:
        record = _QueuedAuditRecord(
            kind=kind,
            event=event,
            plan_id=plan_id,
            structured_input=dict(structured_input),
            generated_text=generated_text,
            response_payload=dict(response_payload or {}),
            metadata=dict(metadata or {}),
        )
        self._buffer.append(record)
        if len(self._buffer) >= self._batch_size:
            self.flush()

    def flush(self) -> None:
        if not self._buffer:
            return
        session = self._session_factory()
        try:
            session.bulk_save_objects(
                [
                    AuditTrailEntry(
                        kind=record.kind,
                        event=record.event,
                        plan_id=record.plan_id,
                        structured_input=dict(record.structured_input),
                        generated_text=record.generated_text,
                        response_payload=dict(record.response_payload),
                        context_metadata=dict(record.metadata),
                    )
                    for record in self._buffer
                ]
            )
            session.commit()
        except Exception:
            session.rollback()
            raise
        finally:
            session.close()
        self._buffer.clear()

    def drain(self) -> None:
        self.flush()

    def __enter__(self) -> "AuditTrailWriter":
        return self

    def __exit__(self, exc_type, exc, tb) -> None:
        if exc is None:
            self.flush()
        else:  # pragma: no cover - defensive cleanup
            self._buffer.clear()


__all__ = ["AuditTrailEntry", "AuditTrailWriter", "Base"]

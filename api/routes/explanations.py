"""REST interface exposing rendered explanations for the UI."""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Callable, Iterable, List, Mapping, Optional, Set

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from persistence.audit import AuditTrailEntry

router = APIRouter(prefix="/explanations", tags=["explanations"])


@dataclass
class Identity:
    """Minimal identity representation for access control."""

    user_id: str
    scopes: Set[str] = field(default_factory=set)

    def has_scope(self, scope: str) -> bool:
        return scope in self.scopes


_session_factory: Optional[Callable[[], Session]] = None
_user_provider: Optional[Callable[[], Optional[Identity]]] = None
_authorizer: Optional[Callable[[Identity], bool]] = None


def configure_session_factory(factory: Callable[[], Session]) -> None:
    global _session_factory
    _session_factory = factory


def configure_user_provider(provider: Callable[[], Optional[Identity]]) -> None:
    global _user_provider
    _user_provider = provider


def configure_authorizer(authorizer: Callable[[Identity], bool]) -> None:
    global _authorizer
    _authorizer = authorizer


def get_session() -> Iterable[Session]:
    if _session_factory is None:
        raise RuntimeError("Session factory has not been configured")
    session = _session_factory()
    try:
        yield session
    finally:
        session.close()


def get_current_user() -> Identity:
    if _user_provider is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication provider missing",
        )
    user = _user_provider()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Unauthenticated",
        )
    return user


def require_explanation_access(user: Identity = Depends(get_current_user)) -> Identity:
    if _authorizer is not None and not _authorizer(user):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")
    if not user.has_scope("explanations:read"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Insufficient scope")
    return user


@router.get("/", summary="List rendered explanations")
def list_explanations(
    *,
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    session: Session = Depends(get_session),
    user: Identity = Depends(require_explanation_access),
) -> Mapping[str, object]:
    del user  # Currently unused beyond access control.

    offset = (page - 1) * page_size
    stmt = (
        select(AuditTrailEntry)
        .order_by(AuditTrailEntry.created_at.desc(), AuditTrailEntry.id.desc())
        .offset(offset)
        .limit(page_size + 1)
    )
    records: List[AuditTrailEntry] = list(session.execute(stmt).scalars())
    has_next = len(records) > page_size
    items = [record.to_dict() for record in records[:page_size]]

    return {
        "page": page,
        "page_size": page_size,
        "has_next": has_next,
        "items": items,
    }


__all__ = [
    "Identity",
    "configure_authorizer",
    "configure_session_factory",
    "configure_user_provider",
    "list_explanations",
    "require_explanation_access",
    "router",
]

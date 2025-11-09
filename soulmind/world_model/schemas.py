"""Pydantic schemas describing structured reasoning proposals."""
from __future__ import annotations

from typing import List, Literal, Sequence

from pydantic import BaseModel, Field, validator


class Hypothesis(BaseModel):
    """Candidate hypothesis inferred from the world model state."""

    statement: str = Field(..., min_length=1, max_length=512)
    likelihood: float = Field(..., ge=0.0, le=1.0)
    supporting_evidence: Sequence[str] = Field(default_factory=list)
    assumptions: Sequence[str] = Field(default_factory=list)
    type: Literal["hypothesis"] = "hypothesis"

    @validator("supporting_evidence", "assumptions", pre=True, each_item=True)
    def _ensure_trimmed(cls, value: str) -> str:
        if not isinstance(value, str):
            raise TypeError("supporting_evidence and assumptions must be strings")
        return value.strip()


class OntologySuggestion(BaseModel):
    """Proposed ontology enrichment for the world model graph."""

    source_concept: str = Field(..., min_length=1, max_length=128)
    relation: str = Field(..., min_length=1, max_length=64)
    target_concept: str = Field(..., min_length=1, max_length=128)
    justification: str = Field(..., min_length=1, max_length=512)
    confidence: float = Field(..., ge=0.0, le=1.0)
    type: Literal["ontology_suggestion"] = "ontology_suggestion"


class CounterExample(BaseModel):
    """Counter example that challenges an existing hypothesis."""

    hypothesis_statement: str = Field(..., min_length=1, max_length=512)
    description: str = Field(..., min_length=1, max_length=512)
    impact: float = Field(..., ge=0.0, le=1.0)
    remediation: str | None = Field(default=None, max_length=512)
    type: Literal["counter_example"] = "counter_example"


Proposal = Hypothesis | OntologySuggestion | CounterExample


class ReasoningBundle(BaseModel):
    """Structured grouping of reasoning proposals returned by the assistant."""

    hypotheses: List[Hypothesis] = Field(default_factory=list)
    ontology: List[OntologySuggestion] = Field(default_factory=list)
    counter_examples: List[CounterExample] = Field(default_factory=list)

    def __iter__(self):
        for proposal in (*self.hypotheses, *self.ontology, *self.counter_examples):
            yield proposal


__all__ = [
    "Hypothesis",
    "OntologySuggestion",
    "CounterExample",
    "Proposal",
    "ReasoningBundle",
]

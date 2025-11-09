"""Pydantic models describing the perception ontology."""
from __future__ import annotations

from datetime import datetime
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, Field, model_validator


class Observation(BaseModel):
    """Raw sensory or narrative information captured by the system."""

    observation_id: str = Field(..., description="Stable identifier for the observation")
    actor: str = Field(..., description="Entity performing or experiencing the observation")
    description: str = Field(..., description="Natural language summary of the observation")
    emotion: Optional[str] = Field(
        None, description="Emotion detected for the actor within the observation"
    )
    cause: Optional[str] = Field(
        None,
        description="High-level cause or trigger for the observation, if known",
    )
    start_time: datetime = Field(
        ..., description="Timestamp marking when the observation began"
    )
    end_time: Optional[datetime] = Field(
        None, description="Timestamp marking when the observation concluded"
    )
    confidence: float = Field(
        1.0,
        ge=0.0,
        le=1.0,
        description="System confidence in the fidelity of the observation",
    )
    metadata: Dict[str, Any] = Field(
        default_factory=dict,
        description="Arbitrary structured metadata associated with the observation",
    )

    @model_validator(mode="after")
    def validate_time_order(self) -> "Observation":
        if self.end_time is not None and self.end_time < self.start_time:
            raise ValueError("end_time must be greater than or equal to start_time")
        return self


class ConceptNode(BaseModel):
    """Structured representation of a concept extracted from observations."""

    node_id: str = Field(..., description="Unique identifier for the concept node")
    label: str = Field(..., description="Human readable label for the concept")
    actor: Optional[str] = Field(
        None, description="Actor associated with the concept, if applicable"
    )
    emotion: Optional[str] = Field(
        None, description="Primary emotion associated with the concept"
    )
    cause: Optional[str] = Field(
        None, description="Causal attribution for the concept"
    )
    start_time: Optional[datetime] = Field(
        None, description="When the concept becomes active or relevant"
    )
    end_time: Optional[datetime] = Field(
        None, description="When the concept ceases to be active or relevant"
    )
    confidence: float = Field(
        1.0, ge=0.0, le=1.0, description="Confidence in the validity of the concept"
    )
    description: Optional[str] = Field(
        None, description="Optional rich description of the concept"
    )
    supporting_observations: List[str] = Field(
        default_factory=list,
        description="Identifiers of observations supporting this concept",
    )

    @model_validator(mode="after")
    def validate_time_order(self) -> "ConceptNode":
        if (
            self.end_time is not None
            and self.start_time is not None
            and self.end_time < self.start_time
        ):
            raise ValueError("end_time must be greater than or equal to start_time")
        return self


class ConceptEdge(BaseModel):
    """Relationship between two concept nodes in the ontology graph."""

    edge_id: Optional[str] = Field(
        None, description="Optional identifier for the edge for traceability"
    )
    source: str = Field(..., description="Identifier of the source concept node")
    target: str = Field(..., description="Identifier of the target concept node")
    relation: str = Field(..., description="Semantic relation between source and target")
    actor: Optional[str] = Field(
        None, description="Actor perspective for the relationship"
    )
    emotion: Optional[str] = Field(
        None, description="Emotion context for the relationship"
    )
    cause: Optional[str] = Field(None, description="Cause underlying the relationship")
    start_time: Optional[datetime] = Field(
        None, description="When the relationship becomes active"
    )
    end_time: Optional[datetime] = Field(
        None, description="When the relationship stops being active"
    )
    confidence: float = Field(
        1.0, ge=0.0, le=1.0, description="Confidence that the relationship holds"
    )
    rationale: Optional[str] = Field(
        None, description="Short explanation of why the relationship exists"
    )

    @model_validator(mode="after")
    def validate_time_order(self) -> "ConceptEdge":
        if (
            self.end_time is not None
            and self.start_time is not None
            and self.end_time < self.start_time
        ):
            raise ValueError("end_time must be greater than or equal to start_time")
        return self

"""Prompt templates for transforming observations into concept graphs."""
from __future__ import annotations

import json
from datetime import date, datetime
from typing import Any, Mapping, Sequence

from jinja2 import Environment

from .schemas import ConceptEdge, ConceptNode, Observation

_ENV = Environment(trim_blocks=True, lstrip_blocks=True)

_OBSERVATION_SCHEMA = json.dumps(Observation.model_json_schema(), indent=2)
_NODE_SCHEMA = json.dumps(ConceptNode.model_json_schema(), indent=2)
_EDGE_SCHEMA = json.dumps(ConceptEdge.model_json_schema(), indent=2)

_OBSERVATION_FEWSHOT = {
    "observations": [
        {
            "observation_id": "obs-demo-1",
            "actor": "Mira",
            "description": "Mira anxiously checks the window because she hears distant sirens.",
            "emotion": "anxiety",
            "cause": "hearing sirens",
            "start_time": "2024-05-11T09:12:00Z",
            "end_time": "2024-05-11T09:14:00Z",
            "confidence": 0.78,
        }
    ],
    "expected": {
        "nodes": [
            {
                "node_id": "concept-demo-1",
                "label": "Mira senses emergency",
                "actor": "Mira",
                "emotion": "anxiety",
                "cause": "Distant sirens suggest danger",
                "confidence": 0.72,
                "supporting_observations": ["obs-demo-1"],
            }
        ],
        "edges": [
            {
                "edge_id": "edge-demo-1",
                "source": "concept-demo-1",
                "target": "concept-demo-1",
                "relation": "is_about",
                "confidence": 0.6,
            }
        ],
        "uncertainty": 0.28,
    },
}

_GAP_FEWSHOT = {
    "partial": {
        "observation_id": "obs-gap-1",
        "nodes": [
            {
                "node_id": "concept-gap-1",
                "label": "Avery awaits feedback",
                "actor": "Avery",
                "confidence": 0.5,
            }
        ],
        "edges": [],
    },
    "missing": ["emotion", "cause"],
    "cue": "Emotion likely nervous anticipation because the email is unread.",
}


_OBSERVATION_TEMPLATE = _ENV.from_string(
    """
You translate observations into ontology compliant JSON.

Schema guide:
Observation schema:
{{ observation_schema }}
ConceptNode schema:
{{ node_schema }}
ConceptEdge schema:
{{ edge_schema }}

Example input:
{{ fewshot.observations | tojson(indent=2) }}
Example output:
{{ fewshot.expected | tojson(indent=2) }}

Instructions:
- Return a JSON object with a "results" array.
- Each element must have "observation_id", "nodes", "edges", and "uncertainty" (0-1 where higher is more uncertain).
- Nodes and edges must validate against the schemas.
- Respect timestamps and confidence scores supplied in the observations.

Now process the following observations:
{% for obs in observations %}Observation {{ loop.index }}:
{{ obs | tojson(indent=2) }}
{% endfor %}
"""
)

_GAP_TEMPLATE = _ENV.from_string(
    """
You repair partially parsed concept graphs.

You received the following observations:
{% for obs in observations %}- {{ obs.observation_id }}: {{ obs.description }}
{% endfor %}

The previous response was:
{{ previous_response | tojson(indent=2) }}

Validation error:
{{ validation_error }}

Use the schemas:
Observation:
{{ observation_schema }}
ConceptNode:
{{ node_schema }}
ConceptEdge:
{{ edge_schema }}

Reference fix example:
{{ fewshot.partial | tojson(indent=2) }}
Missing fields from example: {{ fewshot.missing | tojson() }}
Hint: {{ fewshot.cue }}

Return a corrected JSON response with the same "results" layout as specified above.
"""
)


def render_observation_to_concepts(observations: Sequence[Observation]) -> str:
    serialized = [jsonable(o) for o in observations]
    return _OBSERVATION_TEMPLATE.render(
        observations=serialized,
        observation_schema=_OBSERVATION_SCHEMA,
        node_schema=_NODE_SCHEMA,
        edge_schema=_EDGE_SCHEMA,
        fewshot=_OBSERVATION_FEWSHOT,
    )


def render_gap_filling(
    observations: Sequence[Observation],
    previous_response: Mapping[str, Any],
    validation_error: str,
) -> str:
    return _GAP_TEMPLATE.render(
        observations=observations,
        previous_response=previous_response,
        validation_error=validation_error,
        observation_schema=_OBSERVATION_SCHEMA,
        node_schema=_NODE_SCHEMA,
        edge_schema=_EDGE_SCHEMA,
        fewshot=_GAP_FEWSHOT,
    )


def jsonable(model: Observation | ConceptNode | ConceptEdge | Mapping[str, Any] | Sequence[Any]) -> Any:
    if isinstance(model, (Observation, ConceptNode, ConceptEdge)):
        return jsonable(model.model_dump())
    if isinstance(model, (datetime, date)):
        return model.isoformat()
    if isinstance(model, Mapping):
        return {key: jsonable(value) for key, value in model.items()}
    if isinstance(model, (list, tuple)):
        return [jsonable(item) for item in model]
    return model


__all__ = [
    "render_observation_to_concepts",
    "render_gap_filling",
    "jsonable",
]

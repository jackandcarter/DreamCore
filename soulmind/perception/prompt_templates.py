"""Prompt templates for transforming observations into concept graphs."""
from __future__ import annotations

import json
from datetime import date, datetime
from typing import Any, Mapping, Sequence

from .schemas import ConceptEdge, ConceptNode, Observation

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


def _format_observation_prompt(observations: Sequence[Observation]) -> str:
    blocks = []
    for idx, observation in enumerate(observations, start=1):
        payload = json.dumps(jsonable(observation), indent=2)
        blocks.append(f"Observation {idx}:\n{payload}")
    return "\n".join(blocks)


def render_observation_to_concepts(observations: Sequence[Observation]) -> str:
    observations_block = _format_observation_prompt(observations)
    example_input = json.dumps(_OBSERVATION_FEWSHOT["observations"], indent=2)
    example_output = json.dumps(_OBSERVATION_FEWSHOT["expected"], indent=2)
    return (
        "You translate observations into ontology compliant JSON.\n\n"
        "Schema guide:\n"
        f"Observation schema:\n{_OBSERVATION_SCHEMA}\n"
        f"ConceptNode schema:\n{_NODE_SCHEMA}\n"
        f"ConceptEdge schema:\n{_EDGE_SCHEMA}\n\n"
        "Example input:\n"
        f"{example_input}\n"
        "Example output:\n"
        f"{example_output}\n\n"
        "Instructions:\n"
        "- Return a JSON object with a \"results\" array.\n"
        "- Each element must have \"observation_id\", \"nodes\", \"edges\", and \"uncertainty\" (0-1 where higher is more uncertain).\n"
        "- Nodes and edges must validate against the schemas.\n"
        "- Respect timestamps and confidence scores supplied in the observations.\n\n"
        "Now process the following observations:\n"
        f"{observations_block}"
    )


def render_gap_filling(
    observations: Sequence[Observation],
    previous_response: Mapping[str, Any],
    validation_error: str,
) -> str:
    observations_lines = "\n".join(
        f"- {obs.observation_id}: {obs.description}" for obs in observations
    )
    previous_json = json.dumps(previous_response, indent=2)
    partial_example = json.dumps(_GAP_FEWSHOT["partial"], indent=2)
    missing = json.dumps(_GAP_FEWSHOT["missing"])
    cue = _GAP_FEWSHOT["cue"]
    return (
        "You repair partially parsed concept graphs.\n\n"
        "You received the following observations:\n"
        f"{observations_lines}\n\n"
        "The previous response was:\n"
        f"{previous_json}\n\n"
        "Validation error:\n"
        f"{validation_error}\n\n"
        "Use the schemas:\n"
        f"Observation:\n{_OBSERVATION_SCHEMA}\n"
        f"ConceptNode:\n{_NODE_SCHEMA}\n"
        f"ConceptEdge:\n{_EDGE_SCHEMA}\n\n"
        "Reference fix example:\n"
        f"{partial_example}\n"
        f"Missing fields from example: {missing}\n"
        f"Hint: {cue}\n\n"
        "Return a corrected JSON response with the same \"results\" layout as specified above."
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

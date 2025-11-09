"""Prompt templates used to drive structured world model reasoning."""
from __future__ import annotations

from textwrap import dedent


def hypothesis_generation(summary: str) -> str:
    """Prompt template guiding the model to propose hypotheses."""

    return dedent(
        f"""
        You are an analyst maintaining a cognitive world model. Based on the
        following JSON summary of the current graph, infer 1-3 high-value
        hypotheses that could explain emergent dynamics. Each hypothesis must
        include supporting evidence identifiers and explicit assumptions.

        World model snapshot:
        ```json
        {summary}
        ```

        Respond with JSON using the schema:
        {{
          "hypotheses": [
            {{
              "statement": "...",
              "likelihood": 0.0-1.0,
              "supporting_evidence": ["node-id", "metric-name"],
              "assumptions": ["explicit assumption"]
            }}
          ]
        }}
        """
    ).strip()


def ontology_enrichment(summary: str) -> str:
    """Prompt template that requests ontology refinement suggestions."""

    return dedent(
        f"""
        You are updating the ontology powering a world model graph. Review the
        snapshot below and suggest precise ontology enrichments that would make
        reasoning more expressive. Focus on missing relations or concept links
        grounded in the evidence.

        Snapshot JSON:
        ```json
        {summary}
        ```

        Respond with JSON using the schema:
        {{
          "ontology_suggestions": [
            {{
              "source_concept": "...",
              "relation": "...",
              "target_concept": "...",
              "justification": "...",
              "confidence": 0.0-1.0
            }}
          ]
        }}
        """
    ).strip()


def counterfactual_scenarios(summary: str) -> str:
    """Prompt template that elicits counterfactuals challenging hypotheses."""

    return dedent(
        f"""
        Consider the world model snapshot below and identify counterfactual
        scenarios that could invalidate or stress-test prevailing hypotheses.
        Highlight potential consequences and mitigation steps if the
        counterfactual were observed.

        Snapshot JSON:
        ```json
        {summary}
        ```

        Respond with JSON using the schema:
        {{
          "counter_examples": [
            {{
              "hypothesis_statement": "...",
              "description": "...",
              "impact": 0.0-1.0,
              "remediation": "optional mitigation"
            }}
          ]
        }}
        """
    ).strip()


__all__ = [
    "hypothesis_generation",
    "ontology_enrichment",
    "counterfactual_scenarios",
]

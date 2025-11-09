"""Prompt templates used to elicit structured explanations from the LLM."""
from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Iterable, List, Mapping


@dataclass(frozen=True)
class ExplanationTemplate:
    """Small helper describing an explanation prompt scaffold."""

    kind: str
    description: str
    required_fields: List[str]
    response_schema: Mapping[str, str]
    prompt_format: str

    def build_prompt(self, **fields: object) -> str:
        """Build the final prompt for the provided fields.

        Raises:
            ValueError: if any required field is missing.
        """

        missing = [field for field in self.required_fields if field not in fields]
        if missing:
            raise ValueError(
                f"Missing required fields for template '{self.kind}': {', '.join(missing)}"
            )

        scaffold = [
            "You are an introspective system tasked with producing a structured explanation.",
            "Respect the JSON schema and include a Markdown summary.",
            "Fill in all required sections explicitly.",
            """Mandatory context:
- Plans under consideration: {plans}
- Probabilities or confidence levels: {probabilities}
- Operational constraints or guardrails: {constraints}""",
            self.prompt_format,
            "Respond strictly with JSON containing the keys: "
            + ", ".join(self.response_schema.keys())
            + ".",
        ]
        return "\n\n".join(scaffold).format(**fields)


class TemplateRegistry:
    """Registry of available explanation templates."""

    def __init__(self) -> None:
        self._templates: Dict[str, ExplanationTemplate] = {}

    def register(self, template: ExplanationTemplate) -> None:
        self._templates[template.kind] = template

    def get(self, kind: str) -> ExplanationTemplate:
        try:
            return self._templates[kind]
        except KeyError as exc:  # pragma: no cover - defensive
            raise KeyError(f"Unknown explanation template: {kind}") from exc

    def available(self) -> Iterable[str]:
        return self._templates.keys()


def _build_default_registry() -> TemplateRegistry:
    registry = TemplateRegistry()

    decision_template = ExplanationTemplate(
        kind="decision_rationale",
        description="Explains why a plan was selected over alternatives.",
        required_fields=[
            "plans",
            "probabilities",
            "constraints",
            "decision",
            "evaluation_metrics",
        ],
        response_schema={
            "markdown": "Human-readable Markdown summary of the reasoning.",
            "decision": "Identifier of the chosen plan.",
            "justification": "Key reasons that drove the decision.",
            "risk_register": "Residual risks that remain after the decision.",
        },
        prompt_format="""Decision context: {decision_context}\n\nChosen plan identifier: {decision}.\nEvaluation metrics: {evaluation_metrics}.\nProvide a concise justification highlighting trade-offs and cite any residual risks.""",
    )
    registry.register(decision_template)

    debrief_template = ExplanationTemplate(
        kind="post_action_debrief",
        description="Summarises outcomes after executing a plan.",
        required_fields=[
            "plans",
            "probabilities",
            "constraints",
            "outcomes",
            "lessons_learned",
        ],
        response_schema={
            "markdown": "Markdown-formatted debrief suitable for operators.",
            "outcome_summary": "Short outcome synopsis.",
            "follow_up_actions": "Recommended next steps.",
            "confidence_shift": "How confidence shifted compared to forecasts.",
        },
        prompt_format="""Action outcomes: {outcomes}.\nDocument the lessons learned ({lessons_learned}) and describe any deviation from expected probabilities.""",
    )
    registry.register(debrief_template)

    summary_template = ExplanationTemplate(
        kind="user_summary",
        description="Tailored summary for end users or stakeholders.",
        required_fields=[
            "plans",
            "probabilities",
            "constraints",
            "audience",
            "key_takeaways",
        ],
        response_schema={
            "markdown": "Markdown recap tailored to the target audience.",
            "call_to_action": "What the user should do next.",
            "confidence_statement": "Plain language translation of probabilities.",
        },
        prompt_format="""Audience profile: {audience}.\nKey takeaways to emphasise: {key_takeaways}.\nTranslate the technical rationale into accessible language while preserving accuracy.""",
    )
    registry.register(summary_template)

    return registry


DEFAULT_TEMPLATE_REGISTRY = _build_default_registry()

__all__ = [
    "ExplanationTemplate",
    "TemplateRegistry",
    "DEFAULT_TEMPLATE_REGISTRY",
]

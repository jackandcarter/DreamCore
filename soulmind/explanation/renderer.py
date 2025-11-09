"""Renderer that turns structured rationales into natural-language explanations."""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Dict, Mapping, MutableMapping, Optional

from .templates import DEFAULT_TEMPLATE_REGISTRY, TemplateRegistry


@dataclass
class StructuredRationale:
    """Data bundle describing a rationale to be rendered."""

    kind: str
    plans: Any
    probabilities: Any
    constraints: Any
    fields: Mapping[str, Any]
    decision_context: Optional[str] = None
    metadata: MutableMapping[str, Any] = field(default_factory=dict)

    def to_template_kwargs(self) -> Dict[str, Any]:
        payload: Dict[str, Any] = {
            "plans": self.plans,
            "probabilities": self.probabilities,
            "constraints": self.constraints,
        }
        payload.update(self.fields)
        if self.decision_context and "decision_context" not in payload:
            payload["decision_context"] = self.decision_context
        return payload

    def to_payload(self) -> Dict[str, Any]:
        """Return a JSON-serialisable payload representing the rationale."""

        return {
            "kind": self.kind,
            "plans": self.plans,
            "probabilities": self.probabilities,
            "constraints": self.constraints,
            "fields": dict(self.fields),
            "decision_context": self.decision_context,
            "metadata": dict(self.metadata),
        }


@dataclass
class RenderedExplanation:
    """Container for a rendered explanation."""

    markdown: str
    structured: Mapping[str, Any]
    template_kind: str
    prompt: str
    raw_response: Mapping[str, Any]


class ExplanationRenderer:
    """Use a template and the LLM client to render rationales deterministically."""

    def __init__(
        self,
        llm_client: Any,
        *,
        templates: TemplateRegistry | None = None,
        temperature: float = 0.0,
    ) -> None:
        self._llm_client = llm_client
        self._templates = templates or DEFAULT_TEMPLATE_REGISTRY
        self._temperature = temperature

    async def render(self, rationale: StructuredRationale) -> RenderedExplanation:
        template = self._templates.get(rationale.kind)
        prompt_kwargs = rationale.to_template_kwargs()
        prompt = template.build_prompt(**prompt_kwargs)

        original_temperature = getattr(self._llm_client, "temperature", None)
        if original_temperature is not None:
            self._llm_client.temperature = self._temperature

        try:
            response: Any = await self._llm_client.generate_structured(prompt)
        finally:
            if original_temperature is not None:
                self._llm_client.temperature = original_temperature

        if not isinstance(response, Mapping):
            raise TypeError("LLM response must be a mapping")

        markdown = str(response.get("markdown", "")).strip()
        return RenderedExplanation(
            markdown=markdown,
            structured=response,
            template_kind=template.kind,
            prompt=prompt,
            raw_response=response,
        )


__all__ = [
    "ExplanationRenderer",
    "RenderedExplanation",
    "StructuredRationale",
]

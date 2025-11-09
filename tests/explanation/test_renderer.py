import asyncio

from soulmind.explanation.renderer import ExplanationRenderer, StructuredRationale
from soulmind.explanation.templates import DEFAULT_TEMPLATE_REGISTRY


class DummyLLM:
    def __init__(self) -> None:
        self.temperature = 0.8
        self.recorded_temperatures = []

    async def generate_structured(self, prompt: str):
        self.recorded_temperatures.append(self.temperature)
        return {"markdown": f"## Explanation\n{prompt}", "echo": prompt}


def test_renderer_enforces_deterministic_temperature():
    llm = DummyLLM()
    renderer = ExplanationRenderer(llm, templates=DEFAULT_TEMPLATE_REGISTRY, temperature=0.0)

    rationale = StructuredRationale(
        kind="decision_rationale",
        plans=[{"id": "plan-a", "description": "Test"}],
        probabilities={"plan-a": 0.7},
        constraints=["stay safe"],
        fields={
            "decision": "plan-a",
            "evaluation_metrics": {"reward": 10},
            "decision_context": "Choosing best plan",
        },
    )

    result = asyncio.run(renderer.render(rationale))

    assert llm.recorded_temperatures == [0.0]
    assert llm.temperature == 0.8
    assert "Explanation" in result.markdown
    assert result.structured["echo"].startswith("You are an introspective system")

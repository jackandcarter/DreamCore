import logging
import sys
from pathlib import Path
from typing import Iterable, Mapping, Sequence

import pytest

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

pytestmark = pytest.mark.anyio("asyncio")

from soulmind.world_model.assistant import WorldModelConfig, WorldModelReasoningAssistant
from soulmind.world_model.schemas import Proposal
from soulmind.world_model.validators import ProposalValidationResult


class StubWorldModel:
    def __init__(self, snapshot: Mapping[str, object]) -> None:
        self.snapshot = snapshot
        self.updates: list[Sequence[Mapping[str, object]]] = []

    async def get_snapshot(self) -> Mapping[str, object]:
        return self.snapshot

    async def update_state(self, proposals: Sequence[Mapping[str, object]]) -> None:
        self.updates.append(proposals)


class StubLLM:
    def __init__(self, responses: Iterable[Mapping[str, object]]) -> None:
        self._responses = list(responses)
        self.prompts: list[str] = []

    async def generate_structured(self, prompt: str) -> Mapping[str, object]:
        self.prompts.append(prompt)
        if not self._responses:
            raise RuntimeError("No more stub responses available")
        return self._responses.pop(0)


class CountingValidator:
    def __init__(self, result: ProposalValidationResult) -> None:
        self.result = result
        self.calls: list[Proposal] = []

    async def validate(self, proposal: Proposal, snapshot: Mapping[str, object]) -> ProposalValidationResult:
        self.calls.append(proposal)
        return self.result


@pytest.fixture()
def reasoning_config() -> WorldModelConfig:
    return WorldModelConfig.from_mapping(
        {
            "load_control": {
                "max_concurrent_cycles": 1,
                "min_interval_seconds": 0,
                "load_average_threshold": 0.95,
            },
            "scheduler": {"interval_seconds": 1, "jitter_seconds": 0},
            "token_limits": {"summary_tokens": 256},
        }
    )


@pytest.fixture()
def snapshot() -> Mapping[str, object]:
    return {
        "nodes": [
            {"id": "node-a", "label": "Kai", "salience": 0.9},
            {"id": "node-b", "label": "Nova", "salience": 0.7},
        ],
        "edges": [
            {"source": "node-a", "target": "node-b", "relation": "supports"},
        ],
        "metrics": {"load_average": 0.2, "cohesion": 0.6},
    }


@pytest.fixture()
def structured_responses() -> list[Mapping[str, object]]:
    return [
        {
            "hypotheses": [
                {
                    "statement": "Kai will continue supporting Nova",
                    "likelihood": 0.72,
                    "supporting_evidence": ["node-a"],
                    "assumptions": ["Nova maintains trust"],
                }
            ]
        },
        {
            "ontology_suggestions": [
                {
                    "source_concept": "Kai",
                    "relation": "trusts",
                    "target_concept": "Nova",
                    "justification": "Support edge indicates trust",
                    "confidence": 0.66,
                }
            ]
        },
        {
            "counter_examples": [
                {
                    "hypothesis_statement": "Kai will continue supporting Nova",
                    "description": "Kai is reassigned to another project",
                    "impact": 0.81,
                    "remediation": "Assign a deputy",
                }
            ]
        },
    ]


async def test_reasoning_cycle_produces_structured_proposals(
    reasoning_config: WorldModelConfig,
    snapshot: Mapping[str, object],
    structured_responses: list[Mapping[str, object]],
) -> None:
    world_model = StubWorldModel(snapshot)
    llm = StubLLM(structured_responses)
    validator = CountingValidator(ProposalValidationResult(accepted=True))
    assistant = WorldModelReasoningAssistant(
        world_model=world_model,
        llm_client=llm,
        config=reasoning_config,
        validators=[validator],
    )

    await assistant.run_reasoning_cycle()

    assert len(world_model.updates) == 1
    payload = world_model.updates[0]
    assert len(payload) == 3
    assert all("type" in proposal for proposal in payload)
    assert len(validator.calls) == 3


async def test_rejections_logged_without_state_mutation(
    caplog: pytest.LogCaptureFixture,
    reasoning_config: WorldModelConfig,
    snapshot: Mapping[str, object],
    structured_responses: list[Mapping[str, object]],
) -> None:
    world_model = StubWorldModel(snapshot)
    llm = StubLLM(structured_responses)

    class RejectingValidator:
        async def validate(
            self, proposal: Proposal, snapshot: Mapping[str, object]
        ) -> ProposalValidationResult:
            return ProposalValidationResult(accepted=False, reason="exceeds threshold")

    assistant = WorldModelReasoningAssistant(
        world_model=world_model,
        llm_client=llm,
        config=reasoning_config,
        validators=[RejectingValidator()],
    )

    caplog.set_level(logging.INFO, logger="soulmind.world_model.assistant")

    await assistant.run_reasoning_cycle()

    assert world_model.updates == []
    assert any("Rejected" in record.message for record in caplog.records)

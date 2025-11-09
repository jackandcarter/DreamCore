import asyncio
import sys
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import AsyncMock

import pytest

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

pytestmark = pytest.mark.anyio("asyncio")


@pytest.fixture
def anyio_backend():
    return "asyncio"

from soulmind.perception.ingestor import (
    BatchingSettings,
    LLMSettings,
    PerceptionConfig,
    PerceptionIngestor,
    ResourceCaps,
)


@pytest.fixture()
def perception_config() -> PerceptionConfig:
    return PerceptionConfig(
        llm=LLMSettings(
            base_url="http://localhost",
            model="mock-model",
            max_tokens=256,
            temperature=0.1,
            rate_limit_per_minute=120,
        ),
        batching=BatchingSettings(
            max_batch_size=8,
            max_latency_ms=50,
            estimated_observation_cost_mb=1,
        ),
        resources=ResourceCaps(ram_cap_mb=1024, gpu_cap_mb=1024),
    )


async def test_schema_validation_success(perception_config: PerceptionConfig) -> None:
    observation = {
        "observation_id": "obs-1",
        "actor": "Kai",
        "description": "Kai smiles after reading a joyful letter.",
        "emotion": "joy",
        "cause": "positive letter",
        "start_time": "2024-06-01T10:00:00Z",
        "end_time": "2024-06-01T10:05:00Z",
        "confidence": 0.92,
    }
    llm_client = SimpleNamespace()
    llm_client.generate_structured = AsyncMock(
        return_value={
            "results": [
                {
                    "observation_id": "obs-1",
                    "nodes": [
                        {
                            "node_id": "node-1",
                            "label": "Kai experiences joy",
                            "actor": "Kai",
                            "emotion": "joy",
                            "cause": "The letter delivers uplifting news",
                            "confidence": 0.88,
                            "supporting_observations": ["obs-1"],
                        }
                    ],
                    "edges": [
                        {
                            "edge_id": "edge-1",
                            "source": "node-1",
                            "target": "node-1",
                            "relation": "expresses",
                            "confidence": 0.8,
                        }
                    ],
                    "uncertainty": 0.12,
                }
            ]
        }
    )
    async with PerceptionIngestor(llm_client=llm_client, config=perception_config) as ingestor:
        result = await ingestor.ingest(observation)
    assert result.observation.observation_id == "obs-1"
    assert len(result.nodes) == 1
    assert result.nodes[0].actor == "Kai"
    assert result.edges[0].relation == "expresses"
    assert pytest.approx(result.uncertainty, rel=1e-5) == 0.12


async def test_batching_coalesces_observations(perception_config: PerceptionConfig) -> None:
    perception_config.batching.max_latency_ms = 100
    llm_client = SimpleNamespace()
    llm_client.generate_structured = AsyncMock(
        return_value={
            "results": [
                {
                    "observation_id": "obs-a",
                    "nodes": [
                        {
                            "node_id": "node-a",
                            "label": "Observation A",
                            "actor": "Alex",
                            "confidence": 0.6,
                            "supporting_observations": ["obs-a"],
                        }
                    ],
                    "edges": [],
                    "uncertainty": 0.4,
                },
                {
                    "observation_id": "obs-b",
                    "nodes": [
                        {
                            "node_id": "node-b",
                            "label": "Observation B",
                            "actor": "Bailey",
                            "confidence": 0.65,
                            "supporting_observations": ["obs-b"],
                        }
                    ],
                    "edges": [],
                    "uncertainty": 0.35,
                },
            ]
        }
    )

    observation_a = {
        "observation_id": "obs-a",
        "actor": "Alex",
        "description": "Alex watches the rain roll in.",
        "emotion": "calm",
        "cause": "soothing rain",
        "start_time": "2024-06-01T09:00:00Z",
        "end_time": "2024-06-01T09:05:00Z",
        "confidence": 0.8,
    }
    observation_b = {
        "observation_id": "obs-b",
        "actor": "Bailey",
        "description": "Bailey worries about the approaching storm.",
        "emotion": "concern",
        "cause": "looming storm",
        "start_time": "2024-06-01T09:02:00Z",
        "end_time": "2024-06-01T09:07:00Z",
        "confidence": 0.75,
    }

    async with PerceptionIngestor(llm_client=llm_client, config=perception_config) as ingestor:
        task_a = asyncio.create_task(ingestor.ingest(observation_a))
        await asyncio.sleep(0)
        task_b = asyncio.create_task(ingestor.ingest(observation_b))
        result_a, result_b = await asyncio.gather(task_a, task_b)

    assert llm_client.generate_structured.call_count == 1
    assert result_a.observation.observation_id == "obs-a"
    assert result_b.observation.observation_id == "obs-b"


async def test_failure_recovery_invokes_gap_prompt(perception_config: PerceptionConfig, monkeypatch: pytest.MonkeyPatch) -> None:
    observation = {
        "observation_id": "obs-gap",
        "actor": "Nova",
        "description": "Nova hesitates before responding to a difficult message.",
        "emotion": "uncertain",
        "cause": "difficult message",
        "start_time": "2024-06-02T11:00:00Z",
        "end_time": "2024-06-02T11:03:00Z",
        "confidence": 0.7,
    }

    gap_prompt_captured: dict[str, str] = {}

    def capture_gap_prompt(observations, previous_response, validation_error):
        gap_prompt_captured["error"] = validation_error
        return "GAP PROMPT"

    monkeypatch.setattr(
        "soulmind.perception.prompt_templates.render_gap_filling",
        capture_gap_prompt,
    )

    llm_client = SimpleNamespace()
    llm_client.generate_structured = AsyncMock(
        side_effect=[
            {"results": [{"observation_id": "obs-gap", "nodes": {"oops": True}, "edges": [], "uncertainty": 0.5}]},
            {
                "results": [
                    {
                        "observation_id": "obs-gap",
                        "nodes": [
                            {
                                "node_id": "node-gap",
                                "label": "Nova deliberates",
                                "actor": "Nova",
                                "emotion": "uncertain",
                                "cause": "difficult message",
                                "confidence": 0.55,
                                "supporting_observations": ["obs-gap"],
                            }
                        ],
                        "edges": [],
                        "uncertainty": 0.45,
                    }
                ]
            },
        ]
    )

    async with PerceptionIngestor(llm_client=llm_client, config=perception_config) as ingestor:
        result = await ingestor.ingest(observation)

    assert llm_client.generate_structured.call_count == 2
    assert "error" in gap_prompt_captured
    assert result.nodes[0].label == "Nova deliberates"
    assert pytest.approx(result.uncertainty, rel=1e-5) == 0.45

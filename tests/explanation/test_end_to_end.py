import asyncio

from fastapi import FastAPI
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.pool import StaticPool
from sqlalchemy.orm import sessionmaker

from api.routes import explanations as explanation_routes
from persistence.audit import AuditTrailEntry, AuditTrailWriter, Base
from self_model.hooks import RationaleHooks
from soulmind.explanation.renderer import ExplanationRenderer, StructuredRationale
from soulmind.explanation.templates import DEFAULT_TEMPLATE_REGISTRY


class EchoLLM:
    def __init__(self) -> None:
        self.temperature = 0.9

    async def generate_structured(self, prompt: str):
        return {
            "markdown": "### Decision Summary\n" + prompt.split("\n", 1)[0],
            "json": {"prompt": prompt},
        }


def test_plan_selection_flow_persists_and_serves_explanation():
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(engine)
    SessionLocal = sessionmaker(bind=engine, expire_on_commit=False)

    explanation_routes.configure_session_factory(SessionLocal)
    explanation_routes.configure_user_provider(
        lambda: explanation_routes.Identity(user_id="tester", scopes={"explanations:read"})
    )
    explanation_routes.configure_authorizer(lambda user: True)

    audit_writer = AuditTrailWriter(SessionLocal, batch_size=1)
    llm = EchoLLM()
    renderer = ExplanationRenderer(llm, templates=DEFAULT_TEMPLATE_REGISTRY, temperature=0.0)
    hooks = RationaleHooks()

    captured = {}

    @hooks.register("plan_selected")
    async def _handle(payload):
        explanation = await renderer.render(payload.rationale)
        audit_writer.enqueue(
            kind=payload.rationale.kind,
            event=payload.event,
            plan_id=payload.plan_id,
            structured_input=payload.rationale.to_payload(),
            generated_text=explanation.markdown,
            response_payload=explanation.structured,
            metadata=payload.metadata,
        )
        audit_writer.flush()
        captured["explanation"] = explanation

    rationale = StructuredRationale(
        kind="decision_rationale",
        plans=[{"id": "plan-42", "summary": "Collect samples"}],
        probabilities={"plan-42": 0.82},
        constraints=["battery must stay above 40%"],
        fields={
            "decision": "plan-42",
            "evaluation_metrics": {"expected_reward": 12},
            "decision_context": "Selecting a reconnaissance plan",
        },
    )

    asyncio.run(hooks.plan_selected("plan-42", rationale, metadata={"actor": "planner"}))

    session = SessionLocal()
    try:
        records = session.query(AuditTrailEntry).all()
    finally:
        session.close()

    assert len(records) == 1
    record = records[0]
    assert record.plan_id == "plan-42"
    assert record.generated_text == captured["explanation"].markdown

    app = FastAPI()
    app.include_router(explanation_routes.router)
    client = TestClient(app)

    response = client.get("/explanations/?page=1&page_size=5")
    assert response.status_code == 200
    payload = response.json()
    assert payload["items"][0]["plan_id"] == "plan-42"
    assert payload["items"][0]["structured_input"]["plans"][0]["summary"] == "Collect samples"

import pytest

from soulmind.explanation.templates import DEFAULT_TEMPLATE_REGISTRY


def test_default_templates_cover_required_kinds():
    expected_kinds = {"decision_rationale", "post_action_debrief", "user_summary"}
    assert expected_kinds.issubset(set(DEFAULT_TEMPLATE_REGISTRY.available()))


@pytest.mark.parametrize("kind", ["decision_rationale", "post_action_debrief", "user_summary"])
def test_required_fields_include_core_dimensions(kind):
    template = DEFAULT_TEMPLATE_REGISTRY.get(kind)
    for field in ("plans", "probabilities", "constraints"):
        assert field in template.required_fields


def test_build_prompt_requires_all_fields():
    template = DEFAULT_TEMPLATE_REGISTRY.get("decision_rationale")
    with pytest.raises(ValueError):
        template.build_prompt(plans=[], probabilities={}, constraints=[], decision="plan")

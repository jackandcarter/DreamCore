"""Explanation rendering utilities for DreamCore's Soulmind module."""

from .renderer import ExplanationRenderer, RenderedExplanation, StructuredRationale
from .templates import (
    DEFAULT_TEMPLATE_REGISTRY,
    ExplanationTemplate,
    TemplateRegistry,
)

__all__ = [
    "ExplanationRenderer",
    "RenderedExplanation",
    "StructuredRationale",
    "ExplanationTemplate",
    "TemplateRegistry",
    "DEFAULT_TEMPLATE_REGISTRY",
]

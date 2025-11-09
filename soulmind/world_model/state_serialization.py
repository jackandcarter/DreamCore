"""Utilities for summarising a world model graph into a compact JSON payload."""
from __future__ import annotations

import json
from collections import Counter
from typing import Any, Mapping, Sequence

DEFAULT_MAX_TOKENS = 512
TOKEN_TO_CHAR_RATIO = 4  # heuristic approximation


def _score_node(node: Mapping[str, Any], degree: int) -> float:
    """Calculate a heuristic salience score for a node."""

    for key in ("salience", "importance", "weight", "confidence", "score"):
        value = node.get(key)
        if isinstance(value, (int, float)):
            return float(value)
    # fall back to degree
    return float(degree)


def _build_degree_map(edges: Sequence[Mapping[str, Any]]) -> Counter[str]:
    degree: Counter[str] = Counter()
    for edge in edges:
        source = edge.get("source")
        target = edge.get("target")
        if isinstance(source, str):
            degree[source] += 1
        if isinstance(target, str):
            degree[target] += 1
    return degree


def _truncate_sequence(items: Sequence[Mapping[str, Any]], limit: int) -> list[Mapping[str, Any]]:
    return list(items[:limit])


def summarise_graph_state(
    nodes: Sequence[Mapping[str, Any]],
    edges: Sequence[Mapping[str, Any]],
    metrics: Mapping[str, Any] | None = None,
    *,
    max_tokens: int = DEFAULT_MAX_TOKENS,
    max_nodes: int | None = None,
    max_edges: int | None = None,
) -> str:
    """Return a compact JSON summary of the world model graph.

    The summary respects approximate token limits by iteratively reducing the
    number of nodes and edges included. The node ordering is determined by a
    salience heuristic that combines explicit importance metrics with graph
    degree. The resulting string is safe to embed in LLM prompts.
    """

    metrics = metrics or {}
    char_budget = max(1, max_tokens * TOKEN_TO_CHAR_RATIO)

    degree_map = _build_degree_map(edges)
    nodes_sorted = sorted(
        nodes,
        key=lambda node: _score_node(node, degree_map.get(node.get("id") or node.get("node_id"), 0)),
        reverse=True,
    )
    edges_sorted = list(edges)

    # initial bounds - default to proportional scaling if not specified
    if max_nodes is None:
        max_nodes = min(len(nodes_sorted), 32)
    if max_edges is None:
        max_edges = min(len(edges_sorted), 64)

    def build_payload(node_limit: int, edge_limit: int) -> str:
        payload = {
            "nodes": [
                {k: v for k, v in node.items() if k not in {"attributes", "metadata"}}
                for node in _truncate_sequence(nodes_sorted, node_limit)
            ],
            "edges": [
                {k: v for k, v in edge.items() if k not in {"attributes", "metadata"}}
                for edge in _truncate_sequence(edges_sorted, edge_limit)
            ],
            "metrics": metrics,
        }
        return json.dumps(payload, separators=(",", ":"), ensure_ascii=False)

    node_limit, edge_limit = max_nodes, max_edges
    summary = build_payload(node_limit, edge_limit)

    while len(summary) > char_budget and (node_limit > 1 or edge_limit > 0):
        if node_limit > 1:
            node_limit = max(1, int(node_limit * 0.8))
        if len(summary) > char_budget and edge_limit > 0:
            edge_limit = max(0, int(edge_limit * 0.8))
        summary = build_payload(node_limit, edge_limit)

    if len(summary) > char_budget:
        # final defensive truncation: drop metrics details
        payload = json.loads(summary)
        payload["metrics"] = {
            k: v for k, v in metrics.items() if isinstance(v, (str, int, float))
        }
        summary = json.dumps(payload, separators=(",", ":"), ensure_ascii=False)[:char_budget]

    return summary


__all__ = ["summarise_graph_state"]

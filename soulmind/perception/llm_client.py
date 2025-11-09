"""Asynchronous client wrapper around a structured-generation LLM endpoint."""
from __future__ import annotations

import asyncio
import json
from typing import Any, Dict, Optional

try:  # pragma: no cover - optional dependency for HTTP calls
    import httpx
except Exception:  # pragma: no cover - fallback stub
    class _MissingAsyncClient:
        def __init__(self, *args: Any, **kwargs: Any) -> None:
            raise RuntimeError("httpx is required to use LLMClient")

        async def aclose(self) -> None:  # pragma: no cover - defensive
            return None

        async def post(self, *args: Any, **kwargs: Any) -> Any:  # pragma: no cover - defensive
            raise RuntimeError("httpx is required to use LLMClient")

    class httpx:  # type: ignore
        AsyncClient = _MissingAsyncClient


class LLMClient:
    """Thin asynchronous client for an OpenAI-compatible or llama.cpp endpoint."""

    def __init__(
        self,
        base_url: str,
        model: str,
        *,
        max_tokens: int = 1024,
        temperature: float = 0.0,
        rate_limit_per_minute: int = 60,
        timeout: Optional[float] = 30.0,
        response_format: Optional[Dict[str, Any]] = None,
    ) -> None:
        self.base_url = base_url.rstrip("/")
        self.model = model
        self.max_tokens = max_tokens
        self.temperature = temperature
        self.rate_limit_per_minute = max(1, rate_limit_per_minute)
        self._timeout = timeout
        self._response_format = response_format or {"type": "json_object"}
        self._client = httpx.AsyncClient(base_url=self.base_url, timeout=timeout)
        self._semaphore = asyncio.Semaphore(self.rate_limit_per_minute)

    async def aclose(self) -> None:
        await self._client.aclose()

    async def _acquire_rate_limit(self) -> None:
        await self._semaphore.acquire()
        asyncio.create_task(self._delayed_release())

    async def _delayed_release(self) -> None:
        await asyncio.sleep(60)
        self._semaphore.release()

    async def generate_structured(self, prompt: str) -> Dict[str, Any]:
        """Request a structured response from the configured model."""

        await self._acquire_rate_limit()
        payload = {
            "model": self.model,
            "messages": [
                {"role": "system", "content": "You are a structured-data extraction assistant."},
                {"role": "user", "content": prompt},
            ],
            "max_tokens": self.max_tokens,
            "temperature": self.temperature,
            "response_format": self._response_format,
        }
        response = await self._client.post("/v1/chat/completions", json=payload)
        response.raise_for_status()
        data = response.json()
        if "choices" not in data or not data["choices"]:
            raise RuntimeError("LLM response missing choices field")
        message = data["choices"][0].get("message", {})
        content = message.get("content")
        if not content:
            raise RuntimeError("LLM response missing content")
        try:
            return json.loads(content)
        except json.JSONDecodeError as exc:  # pragma: no cover - defensive
            raise RuntimeError("LLM response was not valid JSON") from exc


__all__ = ["LLMClient"]

"""Pytest configuration providing lightweight async test support."""
from __future__ import annotations

import asyncio
import inspect

import pytest


@pytest.hookimpl(tryfirst=True)
def pytest_pyfunc_call(pyfuncitem: pytest.Function) -> bool | None:
    test_function = pyfuncitem.obj
    if inspect.iscoroutinefunction(test_function):
        loop = asyncio.new_event_loop()
        try:
            argnames = getattr(pyfuncitem._fixtureinfo, "argnames", ())  # type: ignore[attr-defined]
            kwargs = {name: pyfuncitem.funcargs[name] for name in argnames}
            loop.run_until_complete(test_function(**kwargs))
        finally:
            loop.run_until_complete(_shutdown_asyncgens(loop))
            loop.close()
        return True
    return None


async def _shutdown_asyncgens(loop: asyncio.AbstractEventLoop) -> None:
    if hasattr(loop, "shutdown_asyncgens"):
        await loop.shutdown_asyncgens()


def pytest_configure(config: pytest.Config) -> None:
    config.addinivalue_line(
        "markers", "anyio(mode): mark test as requiring the lightweight asyncio runner"
    )

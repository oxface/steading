# seneschal api

FastAPI backend for the Seneschal cluster-operations companion. The current scaffold exposes only the first health/root behavior; SQLAlchemy, PostgreSQL, provider adapters, MCP consumption, and LangGraph arrive in the delivery stages where their training exercises begin.

Every `.py` file is written by the user. See the repository [training protocol](../../../docs/training/README.md) and [Python tracker](../../../docs/training/python.md) before extending the API.

## Commands

Run from this directory:

```text
uv run fastapi dev
uv run pytest
uv run ruff check .
uv run ruff format --check .
uv run pyright
```

Python 3.14 is the API runtime. Ollama runs separately on the Windows host; provider-specific details stay behind an application adapter.

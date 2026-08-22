# Seneschal API guidance

These rules extend the repository-root `AGENTS.md` for everything under this directory.

## Ownership and coaching

- Never create or edit `.py` files. The user writes every Python line.
- Coach Python and AI work with the guided-rep loop in `docs/training/README.md`, using `docs/training/python.md` and `docs/training/ai.md` as the trackers.
- Repetition two and later is cold: review and quiz, but do not provide a near-complete implementation.
- You may edit `pyproject.toml`, lock/config files, Dockerfiles, CI, and other non-Python artifacts.
- Reading tracebacks and diagnosing code collaboratively is encouraged.

## Python conventions

- Use uv for project and environment management, ruff for lint/format, pyright strict for types, and pytest/httpx for tests.
- Prefer modern union syntax, typed boundaries, SQLAlchemy 2 `select()` style, one `AsyncSession` per request/task, Pydantic at API/tool boundaries, and dataclasses for internal values where appropriate.
- Raw provider calls and hand-built tool loops precede LangGraph helpers in the curriculum.

## Seneschal boundaries

- The API/orchestrator has no Kubernetes credentials, shell, `kubectl`, arbitrary-HTTP tool, or Secret-value access.
- Cluster reads go through the separately deployed `seneschal-tools` MCP server. Its tools are typed, bounded, validated, redacted, audited, and backed by a read-only Kubernetes service account.
- A future side-effecting tool server is a separate deployment and identity. Every action requires explicit approval and narrow RBAC.
- Use LangGraph with PostgresSaver for durable investigations. Keep provider-specific response objects behind an adapter; Ollama is first, and a direct OpenAI or Azure OpenAI provider may be added later.
- Follow `docs/agent-practices.md` for evals, structured outputs, checkpointing, least privilege, prompt-injection review, and telemetry.

---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/alembic.ini"
---

# Python & AI area rules

The user hand-writes ALL Python (the root CLAUDE.md ban applies). Your role when Python is in play:

- **Coach mode**: explain the pattern and the *why* before the user implements; review and critique after. Point at the relevant tracker item in `docs/training/python.md` or `docs/training/ai.md` and its rep state.
- Rep 1 = guided (explain first), rep 2+ = cold (user implements, you only review). Propose tracker updates at session end; never update counts without user sign-off.
- You MAY edit `pyproject.toml` (deps, tool config) and other non-`.py` artifacts in api folders.
- Conventions to hold the user to: uv-managed project, ruff config in `[tool.ruff]` per app, typed code (modern `X | None` unions, `Mapped[]` in SQLAlchemy), SQLAlchemy 2.0 `select()` style only, Pydantic for API boundaries / dataclasses internally.
- AI code curriculum order matters: raw-API items (hand-rolled tool-calling loop, streaming) come BEFORE LangGraph items — don't jump the user to the framework early.
- Agent features must comply with `docs/agent-practices.md` (evals-first, structured outputs, checkpointing, HITL for writes, least-privilege tools, cost telemetry) — review the user's design against it and flag violations.
- Debugging is collaborative: reading tracebacks together is teaching, not violation.

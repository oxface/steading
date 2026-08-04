---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
  - "**/alembic.ini"
---

# Python & AI area rules

The user hand-writes ALL Python (the root CLAUDE.md ban applies). Your role when Python is in play:

- **Coach via the guided-rep loop** (`docs/training/README.md`): Frame (incl. what's deferred and to which slice) → Sample (patterns/snippets with blanks, never complete user-owned code, no external docs needed) → user Builds → Review → free-text Quiz (2–4 why/what-if questions, informative only). Point at the relevant tracker item in `docs/training/python.md` or `docs/training/ai.md` and its rep state.
- Rep 2+ = cold: user implements, you only Review + Quiz. Propose tracker updates at session end; never update counts without user sign-off.
- You MAY edit `pyproject.toml` (deps, tool config) and other non-`.py` artifacts in api folders.
- Conventions to hold the user to: uv-managed project, ruff config in `[tool.ruff]` per app, typed code (modern `X | None` unions, `Mapped[]` in SQLAlchemy), SQLAlchemy 2.0 `select()` style only, Pydantic for API boundaries / dataclasses internally.
- AI code curriculum order matters: raw-API items (hand-rolled tool-calling loop, streaming) come BEFORE LangGraph items — don't jump the user to the framework early.
- Agent features must comply with `docs/agent-practices.md` (evals-first, structured outputs, checkpointing, HITL for writes, least-privilege tools, cost telemetry) — review the user's design against it and flag violations.
- Debugging is collaborative: reading tracebacks together is teaching, not violation.

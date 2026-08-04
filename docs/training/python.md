# Python Training Plan & Tracker

Rule: every `.py` file is hand-written, permanently. This tracker sets the *curriculum order* and tells the agent how much coaching each concept still needs.

## Learning outcomes (what mastery looks like)

1. Read and write idiomatic, fully-typed modern Python without mentally translating from C#.
2. Own an async web service end to end: routing, DI, DB, auth, tests, packaging.
3. Understand SQLAlchemy session/transaction semantics well enough to debug them, not just use them.
4. Set up a new uv/ruff/pytest project from scratch in minutes, from memory.
5. Understand the async model deeply enough to debug hangs, races, and cancellation.

## Language core
- [ ] uv workflow: init, add, lock, sync, run — 0/2
- [ ] modules, packages, imports, `__init__.py` — 0/2
- [ ] typing: modern built-ins, `X | None`, type aliases — 0/2
- [ ] typing: `TypeVar`/generics, `Protocol` (structural typing) — 0/2
- [ ] typing deep-dive: `Annotated` and metadata-driven APIs (FastAPI/Pydantic style) — 0/2
- [ ] typing deep-dive: `TypedDict`, `Literal`, `@overload` — 0/2
- [ ] typing deep-dive: abstract types discipline — accept `Iterable`/`Sequence`/`Mapping`, return concrete — 0/2
- [ ] typing deep-dive: `ParamSpec`/`Concatenate` for typed decorators — 0/1
- [ ] typing deep-dive: pyright strict — read and fix its errors as a workflow — 0/2
- [ ] dataclasses vs Pydantic models — when each — 0/2
- [ ] enums and `Literal` — 0/2
- [ ] comprehensions and generator expressions — 0/2
- [ ] generators, `yield`, lazy iteration — 0/2
- [ ] decorators (write one, `functools.wraps`) — 0/2
- [ ] context managers: `with`, `@contextmanager` — 0/3
- [ ] custom exception hierarchy, `raise from` — 0/2
- [ ] pattern matching (`match/case`) — 0/2
- [ ] `pathlib`, f-strings, stdlib fluency — 0/2
- [ ] async/await: coroutines, tasks, `gather`, cancellation — 0/3
- [ ] async context managers and async generators — 0/2

## Pydantic
- [ ] BaseModel: validation, field/model validators — 0/2
- [ ] serialization: `model_dump`, aliases, computed fields — 0/2
- [ ] settings via pydantic-settings + `.env` — 0/2
- [ ] deep-dive: custom types via `Annotated` validators/serializers — 0/2
- [ ] deep-dive: `TypeAdapter` and validating non-model data — 0/2
- [ ] deep-dive: generic models, discriminated unions — 0/2

## SQLAlchemy 2.0
- [ ] declarative models with typed `Mapped[]` — 0/2
- [ ] `select()`-style queries, joins, aggregates — 0/3
- [ ] session lifecycle, unit-of-work, transactions — 0/2
- [ ] relationships + loading strategies (lazy/selectin/joined) — 0/2
- [ ] alembic migrations: autogenerate, review, apply — 0/2

## FastAPI
- [ ] routing: path/query/body params, response models — 0/2
- [ ] dependency injection: `Depends`, yield-dependencies — 0/3
- [ ] cookie-session auth + middleware — 0/2
- [ ] error handling: exception handlers, problem responses — 0/2
- [ ] lifespan events, app factory pattern — 0/2
- [ ] streaming responses (SSE for the agent chat) — 0/2

## Testing & tooling
- [ ] pytest: fixtures, parametrize, conftest — 0/3
- [ ] httpx AsyncClient tests + dependency overrides — 0/2
- [ ] ruff: configure rules in pyproject, triage findings — 0/2

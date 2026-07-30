# steading

Self-education homelab platform: a local k3s cluster with shared services (Postgres + pgvector, Argo CD, OTel/LGTM, local LLM inference) hosting independent apps. App #1 is **seneschal**, an agentic ops assistant for the cluster itself (FastAPI + LangGraph api, React SPA web). A future App #2 (personal assistant, likely named `equerry`) is planned for — namespace-per-app and Argo app-of-apps from day one — but not built.

This is a *learning* project for a Principal .NET engineer deliberately working outside their day-job stack. It will only ever run on their homelab; optimize for learning value and correctness over enterprise ceremony.

## Read first

- `docs/stack.md` — canonical stack decisions **with rationale and revisit-conditions**. Follow them; don't re-litigate settled choices. Update the doc when a decision genuinely changes.
- `docs/roadmap.md` — vision, expansion-readiness rules, and the vertical-slice plan. Work happens in slice order; each slice ends with something deployed and working. No deadlines — order matters, speed doesn't.

## Hard constraints (from decisions — see docs for why)

- Never propose Next.js, Temporal, Azure Durable Functions, or MongoDB.
- Postgres-first for all persistence needs.
- FE stack: React + TS + Vite + Tailwind v4 + shadcn/ui + TanStack Router/Query; React Compiler ON; Zustand only for true client state.
- BE stack: FastAPI + Pydantic + SQLAlchemy, managed with uv, linted with ruff.
- Agents: LangGraph with PostgresSaver checkpointing; DBOS Transact when business workflows appear.
- Names: lowercase everywhere machine-visible (repos, images, namespaces, packages); no trendy suffixes.

## Learning mode — important

The user's FE experience is mostly agent-generated code; **the explicit goal of FE slices is hand-writing code to internalize patterns**. In FE work: explain the pattern and the why, review and critique the user's code, scaffold configs/boilerplate when asked — but do not bulk-generate feature code unless the user explicitly asks. BE, infra, and glue code are normal collaboration. When a genuinely better pattern than the docs prescribe exists, say so — the user wants pushback, not compliance.

## Environment

- Windows 11 host; k3s runs in WSL2. GPU: 16GB VRAM (CUDA-on-WSL; nvidia device plugin — roadmap slice 7).
- ollama serves models on the Windows host until in-cluster vLLM lands.
- Local dev before cluster: docker compose for Postgres.

## Layout

```
apps/seneschal/web/   # React SPA
apps/seneschal/api/   # FastAPI + LangGraph
platform/             # k8s manifests, Argo apps, o11y, inference
docs/                 # vision, roadmap, stack decisions
```

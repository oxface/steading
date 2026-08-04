# steading

Self-education homelab platform: a local k3s cluster with shared services (Postgres + pgvector, Flux GitOps, Envoy Gateway, OTel + Victoria/Grafana/Tempo, local LLM inference) hosting independent apps. App #1 is **seneschal**, an agentic ops assistant for the cluster (FastAPI + LangGraph api, React SPA web). App #2 (personal assistant, likely `equerry`) is planned-for but not built.

A *learning* project for a Principal .NET engineer deliberately working outside their day-job stack. Optimize for learning value and correctness over enterprise ceremony. The user wants pushback, not compliance — if a better pattern than the docs prescribe exists, say so.

## Read before acting

- `docs/stack.md` — canonical stack decisions with rationale. Don't re-litigate settled choices; update the doc when one genuinely changes.
- `docs/roadmap.md` — vision, expansion rules, vertical-slice plan. Work in slice order; each slice ends deployed. No deadlines.
- `docs/training/README.md` — the mastery-gate protocol. Area-specific rules live in `.claude/rules/` and load when you touch matching files.
- `docs/agent-practices.md` — binding agent-engineering practices (evals-first, structured outputs, HITL for writes, least privilege, cost telemetry). A slice violating them isn't done.

## Always-binding (safety net — full protocol in rules/training docs)

1. **Never write `.py` files. No exceptions.** All Python (backend AND AI/LangGraph) is hand-written by the user. This applies to *creating* files too, before any rule triggers.
2. The user personally runs all CLI scaffolds and infra setup/debug commands — hint the command, don't execute.
3. **At slice start, partition**: scan the slice plan against `docs/training/*.md` trackers and pre-assign non-graduated concepts to the user before writing any code.
4. Tracker updates only with explicit user sign-off, proposed at session end.
5. Never propose: Next.js, Temporal, Azure Durable Functions, MongoDB.
6. Names: lowercase everywhere machine-visible; no trendy suffixes.

## Environment

Windows 11 host; k3s in WSL2; 16GB VRAM GPU; ollama on host until in-cluster vLLM (slice 7). Local dev pre-cluster: docker compose for Postgres.

## Layout

```
apps/seneschal/web/   # React SPA        (rules: .claude/rules/react.md)
apps/seneschal/api/   # FastAPI + LangGraph (rules: .claude/rules/python.md)
platform/             # k8s, Flux, o11y  (rules: .claude/rules/infra.md)
docs/                 # stack, roadmap, training trackers
```

# Stack Decisions

Living document. Decided July 30, 2026 from a five-area trend scan plus follow-up research (raw research lives in the educ workspace, outside this repo). Each entry notes *why* and *when to revisit*.

## Frontend
- **React + TypeScript + Vite** (SPA first; no meta-framework).
- **Tailwind v4 + shadcn/ui** — the assumed 2026 UI layer; fills the biggest personal gap.
- **TanStack Router + TanStack Query**. State rules: server state → Query; URL-shareable state → Router search params; true client state (drafts, wizard steps) → **Zustand** (persist middleware where refresh-survival is needed). Never copy server data into Zustand.
- **React Compiler ON** from day one. Mitigation for legacy-world literacy: one deliberate theory pass on the re-render model (referential equality, why `useMemo`/`useCallback` existed) + one profiling exercise with React DevTools before enabling.
- **Lint/format: ESLint + Prettier** (+ `prettier-plugin-tailwindcss`), decided over Biome because React Compiler's correctness rules ship as ESLint plugins (`eslint-plugin-react-compiler`, `eslint-plugin-react-hooks`) — they're the tutor for hand-learning the Rules of React. Biome stays a watchlist swap-experiment. Config + devDeps live per-app; only the VS Code extensions are workspace-level.
- **TanStack Start: deferred, not rejected.** It layers incrementally on Router; adopt as its own slice if/when SSR or a TS BFF is wanted.
- **Explicitly avoiding Next.js** (Vercel prioritization, CVE-2025-29927 history, opaque client/server split).

## Backend
- **Python: FastAPI + Pydantic + SQLAlchemy, uv + ruff** toolchain. Primary self-education backend.
- **Postgres-first everywhere** (+ pgvector when retrieval arrives). No Mongo/MERN.
- **Auth**: FastAPI httpOnly cookie sessions (Starlette middleware + authlib if external IdP later). With one backend, the API *is* the BFF. Introduce a real BFF (TanStack Start or .NET YARP) as a deliberate slice only when a second backend appears.
- **.NET stays the enterprise anchor** (day job); appears here only as a C# MCP server slice later.
- **Skips**: Blazor (pick-up-on-demand), deep HCL mastery.

## Durable execution (researched July 2026)
- **Start**: LangGraph 1.0 `PostgresSaver` checkpointing — MIT, zero extra infra, covers agent-state durability (resume-after-crash, time travel, human-in-the-loop).
- **Grow**: **DBOS Transact** (MIT, in-process Python library, writes to the same Postgres, no server/sidecar, no license cliff) when real workflow semantics are needed — exactly-once side effects, queues, cron, multi-step business processes. Documented pattern: wrap LangGraph invocations in DBOS workflows.
- Known limit to remember: LangGraph checkpointing is durability *for the graph, not the system* — no task queue, no cross-service orchestration.
- Runners-up: Restate (best-engineered, but BUSL server + own state store), Hatchet (MIT task-queue shape, more pods), **Dapr Workflow** (Apache 2.0/CNCF, first-class .NET SDK — switch to it if .NET parity becomes a hard requirement).
- Rejected: Temporal (freemium gravity), Azure Durable Functions (lock-in, weak local dev).

## AI / agents
- **LangGraph + Python** as the primary agent framework (largest community, aligns with Claude ecosystem, forces the Python stack).
- **MAF**: exposure expected via day job — no personal project needed.
- Framework-independent priorities: **C# MCP server** over a real backend; **eval harness with CI gates**; token/cost telemetry as OTel metrics.
- **Inference**: ollama on the Windows host until the k3s cluster is up; then a GPU-in-cluster slice (WSL2 + NVIDIA container toolkit + device plugin → vLLM) for the production-serving learning. 16GB VRAM ≈ 7–14B models at Q4.

## Infra / DevOps
- **k3s locally** (WSL2 on the Windows PC).
- **GitOps: Argo CD** (researched July 2026 — Flux is healthy post-Weaveworks under ControlPlane and shipping well, but Argo holds ~60% of GitOps clusters per CNCF 2025 survey and dominates job-market value; its UI also accelerates solo learning). Do an afternoon of Flux later for the reconciliation-model purity + Azure Arc relevance.
- **o11y**: OpenTelemetry SDKs end-to-end; LGTM-style stack in-cluster (Grafana + Loki + Tempo + Prometheus/Mimir). eBPF/OBI on the watchlist.
- **IaC**: Pulumi (C# or Python) preferred over deep Terraform/HCL; HCL reading fluency only.

## Watchlist (one deliberate project each, no bets)
Local-first sync engines (Zero/ElectricSQL) · DuckDB (two evenings) · Go for reading infra source · Wasm component in C# · TanStack Start · Flux afternoon.

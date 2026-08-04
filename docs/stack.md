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
- **pnpm** as package manager (strict node_modules catches phantom deps; workspaces if apps multiply).
- **Testing**: Vitest + React Testing Library once real logic appears (not day one); Playwright as a later slice. Forms library decided at the first real form.

## Backend
- **Python: FastAPI + Pydantic + SQLAlchemy, uv + ruff** toolchain. Primary self-education backend. Python 3.13.
- **Async throughout**: async FastAPI + async SQLAlchemy, driver = **psycopg3** (first-class SQLAlchemy 2.0 async, one driver for sync+async; asyncpg is a perf-niche we don't need).
- **Postgres-first everywhere** (+ pgvector when retrieval arrives). No Mongo/MERN. **alembic** from the first real table.
- **Testing**: pytest + httpx `AsyncClient` with dependency overrides.
- **Type checking: pyright** (strict mode; runs in-editor via Pylance, add to CI). ty stays watchlist — still beta (0.0.x, July 2026), ~15% typing-spec conformance, Pydantic support unshipped; re-evaluate at ty 1.0. **uv is both package manager and build backend** (`uv_build`).
- **Auth**: FastAPI httpOnly cookie sessions — start signed-cookie (Starlette `SessionMiddleware`), move to server-side sessions in Postgres as a later deliberate step (authlib if external IdP later). With one backend, the API *is* the BFF. Introduce a real BFF (TanStack Start or .NET YARP) as a deliberate slice only when a second backend appears.
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
- **Inference**: ollama on the Windows host until the k3s cluster is up; then a GPU-in-cluster slice (WSL2 + NVIDIA container toolkit + device plugin → vLLM) for the production-serving learning. 16GB VRAM ≈ 7–14B models at Q4; start with a Qwen3-14B-class instruct model (strong tool calling), easy to swap.
- **Provider strategy: local + Anthropic API, env-switchable** — abstract the LLM client so ollama and the Anthropic API interchange; the abstraction is itself a learning point and dual-provider is how real products ship.
- **Dependencies** (updated July 30, 2026): `langgraph` + `langchain-core` + provider packages (`langchain-anthropic`, ollama). `langchain` 1.x is *allowed* — post-1.0 it's the sanctioned lean agent layer (`create_agent` on the LangGraph runtime; legacy lives in `langchain-classic`, which stays banned). Curriculum still hand-builds the loop and graph before using `create_agent`.
- **Claude Agent SDK comparison spike** (after LangGraph basics graduate): build the same small assistant on the Agent SDK harness and on LangGraph; write up what the harness provides.

## Infra / DevOps
- **k3s locally** (WSL2 on the Windows PC), installed with `--disable traefik`.
- **GitOps: Flux** (revised July 30, 2026 — Operator Web UI went GA with Flux 2.8 in Feb 2026, closing the solo-learner visibility gap; Azure Arc/AKS GitOps is Flux-based (`microsoft.flux`) = direct day-job transfer; CLI-first reconciliation model teaches k8s purely. Known cost: ~11% GitOps market share vs Argo's ~45–60% — mitigated by an **Argo CD comparison spike** later in a scratch namespace).
- **Gateway: Envoy Gateway + Gateway API** (revised July 30, 2026 — Gateway API is the greenfield standard, ingress-nginx EOL March 2026; AKS's native GA path provisions Envoy, so homelab learning = AKS skill). Gateway API resources are the portable knowledge; Envoy is the operational surface.
- **Manifest layering: Kustomize** for our own manifests (base + overlays, Flux-native); **Helm only for installing third-party charts**.
- **o11y**: OpenTelemetry SDKs end-to-end; backend = **VictoriaMetrics + VictoriaLogs + Grafana + Tempo** (revised July 30, 2026 — fraction of LGTM's footprint for a PC-hosted cluster; PromQL transfers to MetricsQL. Known cost: LogsQL ≠ LogQL and job listings assume Prometheus/Loki — mitigated by MetricsQL being a PromQL superset). eBPF/OBI on the watchlist.
- **Secrets**: plain k8s Secrets now; at the secrets slice adopt **ESO** (project healthy again as of 2026 — maintainer crisis resolved, v2.6.0 June 2026) fronting Azure Key Vault (day-job realism) or OpenBao (self-hosted) — decide then.
- **IaC**: Pulumi (C# or Python) preferred over deep Terraform/HCL; HCL reading fluency only.
- **CI**: GitHub Actions. **Registry**: ghcr.io (public images, zero-credential pushes via `GITHUB_TOKEN`).
- **Early third-party workloads**: deploy existing apps (e.g., OpenWebUI → ollama) as soon as GitOps works — real targets for o11y and disaster drills, and the cluster becomes useful before seneschal matures.

## Watchlist (one deliberate project each, no bets)
Local-first sync engines (Zero/ElectricSQL) · DuckDB (two evenings) · Go for reading infra source · Wasm component in C# · TanStack Start · Argo CD comparison spike · ty at 1.0 · eBPF/OBI auto-instrumentation.

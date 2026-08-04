# Product Vision & Roadmap — Steading

## Naming (decided July 30, 2026; all GitHub-collision-checked)

- **steading** — the platform (and repo/subfolder name). A homestead and its working buildings: the estate that hosts things.
- **seneschal** — App #1, the ops assistant. The steward who ran a medieval estate's daily operations.
- **equerry** — reserved candidate for App #2, the personal assistant (verified unique; final call when App #2 starts).

## Vision: the homelab is a lab *for* something

Two-layer design, decided July 30, 2026:

1. **Platform layer (steading)** — the k3s cluster itself with shared services: Postgres (+pgvector), Flux GitOps, Envoy Gateway, OTel + Victoria/Grafana/Tempo observability, inference runtime (ollama on host → vLLM in-cluster). Every app rides on this.
2. **App layer** — independent products deployed *onto* the platform, each with its own UI:
   - **App #1: seneschal — homelab ops assistant** (build now) — agentic assistant over the cluster: MCP tools for kubectl/Argo/Prometheus/Loki queries, LangGraph orchestration, local-model inference, proposes runbook actions. The infra is both platform and domain, so every slice dogfoods itself.
   - **App #2: personal assistant** (planned possibility, not built now; likely name: equerry) — separate UI/product installed in the same cluster later. Leading candidate (July 30, 2026): a **research multi-agent system** — exercises subgraphs, parallel agents, and synthesis that seneschal doesn't.

**Expansion-readiness rules** (cheap now, expensive to retrofit):
- Namespace-per-app; shared services live in platform namespaces.
- Each app = its own Flux Kustomization (per-app reconciliation from the start).
- Platform services (Postgres, inference, o11y) exposed as cluster services, never embedded in an app.
- Auth is per-app for now (FastAPI sessions); if apps multiply, that's the trigger for the BFF/IdP slice.

## Slices

Vertical slices, each ending in something deployed and working. No time budget — work happens when time exists; order matters, deadlines don't.

| # | Slice | Definition of done |
|---|-------|--------------------|
| 0 | **Project scaffold** | New `steading/` subfolder repo (own git, own CLAUDE.md per workspace rules); FE+BE skeletons build locally |
| 1 | **Minimal FE by hand** | Vite + React + TS + Tailwind + shadcn + Router + Query; a real page hand-written (layout, list/detail, form); React Compiler theory pass + profiling exercise done |
| 2 | **Minimal BE** | FastAPI + uv + ruff + SQLAlchemy + Postgres (docker compose); cookie-session auth; FE talks to it |
| 3 | **k3s cluster** | k3s in WSL2; FE, BE, Postgres deployed via plain manifests; app reachable from Windows host |
| 4 | **GitOps** | Flux bootstrapped (Operator + Web UI); per-app Kustomizations; first third-party workload (OpenWebUI → host ollama) deployed via GitOps; manual kubectl retired |
| 5 | **Observability** | OTel SDKs in FE+BE; VictoriaMetrics + VictoriaLogs + Grafana + Tempo in-cluster; traces/logs/metrics visible in Grafana |
| 6 | **First agent** | ollama on host; LangGraph agent in BE with PostgresSaver checkpointing; read-only ops tools (pods, Argo sync status, Prometheus queries); chat UI in FE |
| 7 | **GPU in cluster** | NVIDIA toolkit in WSL2 + k8s device plugin; vLLM deployment serving the model; agent switched to in-cluster endpoint |
| 8 | **Evals + cost** | Eval harness for the agent gated in CI; token/cost telemetry as OTel metrics on the Grafana dashboards |
| 9 | **C# MCP server** | A .NET MCP server (e.g., wrapping cluster ops or a domain service) consumed by the agent; revisit BFF question now that a second backend exists |
| 10+ | **Open** | Disaster drills (node drain, PVC loss + restore, sync-break recovery, and the final boss: delete the cluster, rebuild everything from git); Claude Agent SDK vs LangGraph comparison spike; Argo CD comparison spike; DBOS workflows when a business-workflow need appears; write-action runbooks with human-in-the-loop; App #2 (research multi-agent system); watchlist items |

## GPU-on-k3s note (researched answer)

Yes, k3s on this PC can use the 16GB GPU, with caveats: k3s runs in WSL2; NVIDIA CUDA-on-WSL is mature; inside WSL2 install nvidia-container-toolkit (k3s auto-detects the NVIDIA runtime and creates a `nvidia` RuntimeClass), then deploy the NVIDIA device plugin so pods can request `nvidia.com/gpu`. Known quirks on WSL: no MIG, limited GPU metrics, device-plugin config sometimes needs tweaking. That's why it's its own slice (#7) — interim, cluster workloads can call ollama on the host over the WSL host IP.

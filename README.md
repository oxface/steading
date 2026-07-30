# steading

A self-education homelab platform. A *steading* is a homestead and its working buildings — here, a local k3s cluster with shared services (Postgres + pgvector, Argo CD GitOps, OpenTelemetry/LGTM observability, local LLM inference) that hosts independent apps.

**App #1 — seneschal**: an agentic ops assistant for the cluster itself. LangGraph orchestration, MCP tools over kubectl/Argo/Prometheus/Loki, local-model inference. The infra is both the platform and the domain.

Built as vertical slices, each ending in something deployed — see [docs/roadmap.md](docs/roadmap.md). Stack decisions and their rationale: [docs/stack.md](docs/stack.md).

## Layout

```
apps/seneschal/   # App #1 — ops assistant (web = React SPA, api = FastAPI + LangGraph)
platform/         # cluster: manifests, Argo apps, o11y, inference
docs/             # vision, roadmap, stack decisions
```

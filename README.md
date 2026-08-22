# steading

Steading is a learning-oriented reference cluster for building and operating **Seneschal**. It is one concrete homelab installation, not a generic homelab distribution.

**Seneschal is the product:** an installable cluster-operations companion with a read-only dashboard, an integration catalogue with links into the tools already running in a cluster, and a chatbot that investigates state through a constrained MCP tool server. It starts read-only; narrow approval-gated actions may come later.

The first Steading deployment is a single Ubuntu VM on Hyper-V running k3s, Flux, Traefik Gateway API, Postgres, OpenWebUI, and eventually the observability stack and Seneschal. Ollama stays on the Windows GPU host and is reached over the local Hyper-V network.

Delivery is staged so discoveries can change later choices without front-loading speculative comparison work. See [the roadmap](docs/roadmap.md), [stack decisions](docs/stack.md), [agent engineering practices](docs/agent-practices.md), the [local coding-agent evaluation](docs/local-coding-agent-evaluation.md), and the [current handover](docs/handovers/2026-08-22-containerized-shell-to-thin-steading.md).

## Layout

```text
apps/seneschal/   # Product: React SPA, FastAPI/LangGraph API, later MCP tool server
platform/         # Reference installation: Hyper-V/k3s, Flux, workloads, observability
docs/             # Product direction, architecture decisions, and learning trackers
AGENTS.md          # Repository-wide agent instructions; nested files add scoped rules
.agents/           # Portable agent policies and hook implementations
.codex/            # Thin Codex adapter pointing to portable hooks
```

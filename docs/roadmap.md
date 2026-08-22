# Product Vision & Roadmap

## Product boundary

- **Seneschal is the product.** It should eventually be installable into another cluster, most likely with Helm, without assuming that cluster is Steading.
- **Steading is the first customer and reference installation.** It is a reproducible local cluster used to learn the platform tools, host useful workloads, and exercise Seneschal against real integrations. It is not currently a reusable homelab platform or workload marketplace.
- **OpenWebUI is the first useful workload.** It proves the cluster, GitOps, ingress, persistence, secrets, and Windows-hosted Ollama path before Seneschal tries to observe anything.

This boundary leaves room for a useful tool without pretending to compete with full infrastructure-management products. The near-term value is a coherent operations surface and an agent-engineering learning project, not autonomous cluster administration.

## Seneschal target

Seneschal begins with three user-facing capabilities:

1. A read-only dashboard for cluster and integration health.
2. An integration catalogue, grouped by purpose, with health/status summaries and quick links into each tool's own UI.
3. A chatbot that can answer operational questions and run bounded read-only investigations.

The deployment has two security boundaries from the first agent version:

- `seneschal-api` owns the UI/API, LangGraph orchestration, conversations, and provider adapters. It has no kube credentials, shell, `kubectl`, arbitrary HTTP, or Secret-value access.
- `seneschal-tools` is an internal MCP server with a read-only service account and typed adapters for Kubernetes, Flux, and later observability systems. It validates and bounds inputs, redacts outputs, records audit data, and limits result sizes.

A future `seneschal-actions` server, if justified, is a separate deployment and identity with narrow RBAC and explicit human approval. Read access is not allowed to grow quietly into write access.

## Steading target

The local topology is deliberately small:

```text
Windows 11 host
├── IDE, Git, browser
├── Ollama + physical GPU
└── Hyper-V Default Switch (managed internal/NAT)
    └── Ubuntu VM (on-demand)
        └── single-node k3s
            ├── Traefik Gateway API
            ├── Flux; SOPS when the first Git-managed secret appears
            ├── Postgres
            ├── OpenWebUI
            ├── observability
            └── Seneschal
```

WSL remains useful as a development shell but is not the cluster host. Hyper-V manages the VM address, NAT, and local DNS; Windows uses `steading-cluster.mshome.net` instead of treating the DHCP address as a contract. The unrestricted k3s kubeconfig remains root-only on the VM: SSH is the bootstrap and break-glass path, and routine changes move to Git after Flux is authoritative. A custom internal/NAT network becomes necessary only if the managed endpoint or the later VM-to-Windows Ollama path proves unreliable.

## Delivery stages

Stages are ordered learning and product increments, not deadlines. Each ends with something runnable. Later stages may change when a real limitation is discovered; speculative comparison spikes are not milestones.

| Stage | Outcome | Exit condition |
|---|---|---|
| 0. Minimal local Seneschal | A truthful, build-clean shell with no speculative product infrastructure | Correct Seneschal branding; the SPA shows live API health through TanStack Query; web and API checks pass; no database, auth, agent, MCP, or Ollama integration |
| 1. Containerized shell | The same vertical slice runs in production-shaped containers | Separate production web and API images build; a local container smoke test proves browser to web to API health |
| 2. Thin Steading and one manual deployment | A working cluster plus one visible Kubernetes learning rep | Ubuntu Hyper-V VM with a stable Windows-to-VM hostname over managed internal/NAT; single-node k3s with root-local administration over SSH; Traefik Gateway API enabled; Seneschal `Deployment`, `Service`, `Gateway`, and `HTTPRoute` applied manually once; browser to web to API health succeeds inside k3s |
| 3. GitOps delivery and first useful workload | Flux becomes authoritative early and the cluster hosts something useful | GitHub Actions publishes images to GHCR; Flux is bootstrapped with useful Kustomizations; the manual Seneschal shell is moved under Flux; OpenWebUI reaches Windows-hosted Ollama; SOPS + age is introduced when the first real Git-managed secret appears |
| 4. Read-only Seneschal | The first product-shaped release observes a real environment | Integration catalogue covers OpenWebUI, Flux, and relevant cluster services; read-only dashboard; internal `seneschal-tools` MCP server with Kubernetes and Flux adapters; eval cases precede the first raw model/tool call and LangGraph investigation; PostgreSQL/PostgresSaver is added when durable conversation or graph behavior needs it; read-only RBAC and audit trail |
| 5. Observable Seneschal | Investigations can use and explain telemetry | OTel Collector plus VictoriaMetrics, VictoriaLogs, Grafana, and Tempo; Seneschal integration cards and typed query tools; correlated agent and platform traces/logs/metrics |
| 6. Harden and package | A credible installable operations companion | Automated eval gates, provider capability tests, resource/output limits, prompt-injection review, Helm packaging, backup/rebuild drills, and only then narrowly scoped approval-gated actions if they add value |

The stage 2 manual deployment is deliberately performed exactly once as a learning and diagnostic exercise. It is not a parallel delivery system: stage 3 makes Flux authoritative immediately afterward. Likewise, local coding harness experiments are optional developer tooling and must not delay this sequence or become part of Seneschal's runtime architecture.

## Expansion rules

- Namespace per app; shared cluster services live in platform namespaces.
- One Flux Kustomization per app or independently reconciled platform unit.
- Kustomize owns first-party manifests; Flux HelmRelease resources own third-party charts.
- Provider adapters are capability-based. Ollama is first; direct OpenAI or Azure OpenAI can be added without changing domain code.
- Infrastructure as code, Proxmox, an in-cluster model server, a Flux UI, or an alternate data plane is added only when the current stage exposes a real need.
- A second product is outside the current roadmap. Revisit that possibility only after Seneschal has a useful read-only release.

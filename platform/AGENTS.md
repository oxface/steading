# Steading platform guidance

These rules extend the repository-root `AGENTS.md` for everything under this directory.

## Learning and command ownership

- Check `docs/training/infra.md` before writing manifests or configuration. The user writes non-graduated concepts through the guided-rep loop in `docs/training/README.md`.
- The user executes cluster, Hyper-V, k3s, kubectl, Helm, Flux, Docker, and infrastructure setup/install/debug commands. Give exact commands and explain them; do not run them.
- Read-only inspection is allowed when the user asks for investigation.

## Platform invariants

- The local target is a single Ubuntu Hyper-V VM running single-node k3s. WSL is not the cluster host.
- Use a predictable Hyper-V internal/NAT network so Windows-hosted Ollama and VM-hosted workloads can reach one another without depending on transient addresses.
- Use k3s-bundled Traefik with Gateway API. Do not add Envoy merely for AKS parity.
- Use Kustomize for owned manifests and Flux HelmRelease resources for third-party charts.
- Flux-managed Git state is authoritative; do not use imperative apply for resources Flux owns.
- Use namespace-per-app. Shared services live in platform namespaces, not inside Seneschal.
- The first useful cluster workload is OpenWebUI connected to Ollama on Windows.
- Start secrets with SOPS + age. Add External Secrets Operator only when Azure Key Vault or OpenBao becomes a real source of truth.
- Do not add Proxmox, an in-cluster inference server, or IaC solely to demonstrate a tool. Each requires its documented trigger in `docs/stack.md`.
- Propose tracker updates only at session end and only apply them after user sign-off.

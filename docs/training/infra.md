# Infra Training Plan & Tracker

Rule: collaborative area with mastery gate — agent may draft manifests/config for graduated concepts, but **the user executes all setup, install, and debug commands** to build operational feel.

## Learning outcomes (what mastery looks like)

1. Stand up a GitOps-managed single-node k3s cluster in an Ubuntu Hyper-V VM, unaided.
2. Trace the full path git push → CI → registry → Flux reconciliation → running pod, and debug any broken link in it.
3. Diagnose failing workloads fast with kubectl + observability (logs, traces, metrics).
4. Operate the o11y stack as a user: build dashboards, write PromQL/MetricsQL and LogsQL, read distributed traces.
5. Explain the boundary between the Windows GPU/model host and VM-hosted cluster, including its networking and security tradeoffs.

## Containers
- [~] Dockerfile for the api (multi-stage, uv) — 1/2 (guided, 2026-08-21: dependency-first layers, locked production sync, unprivileged FastAPI runtime, Podman build and smoke test)
- [~] Dockerfile for the web (build + static serve) — 1/2 (guided, 2026-08-21: pnpm build stage, minimal nginx runtime, reverse proxy, Podman build and smoke test)
- [ ] docker compose for local dev (postgres + api) — 0/2
- [x] image/layer mental model, cache-friendly ordering — graduated 2026-08-21

## Hyper-V and k3s / Kubernetes core
- [ ] create/start/stop the Ubuntu Hyper-V VM; size CPU, RAM, disk, and dynamic-memory settings — 0/2
- [ ] configure and explain the managed Hyper-V NAT endpoint; verify VM ↔ Windows Ollama connectivity — 0/2
- [ ] k3s install in the Ubuntu VM; root-local kubeconfig and SSH administration — 0/2
- [ ] Deployment + Service YAML by hand — 0/3
- [ ] enable k3s-bundled Traefik Gateway API support; Gateway + HTTPRoute by hand — 0/2
- [ ] ConfigMaps & Secrets — 0/2
- [ ] namespaces, resource requests/limits — 0/2
- [ ] PersistentVolumeClaim (postgres storage) — 0/2
- [ ] kubectl debugging: describe, logs, exec, events — 0/3
- [ ] helm: install a chart, values files, upgrade — 0/2

## GitOps (Flux)
- [ ] upstream Flux bootstrap and CLI reconciliation — 0/2
- [ ] GitRepository + Kustomization CRs, per-app reconciliation — 0/2
- [ ] Kustomize: base + overlays for own manifests — 0/2
- [ ] HelmRelease for third-party charts via Flux — 0/2
- [ ] SOPS + age: encrypt, reconcile, back up and restore the decryption key — 0/2
- [ ] drift, suspend/resume, rollback via git revert — 0/2
- [ ] flux CLI diagnostics (`flux get/logs/events/trace`) — 0/2
- [ ] after real CLI use, define the missing UI views and select or reject a Flux ecosystem UI — 0/1

## First useful workload
- [ ] deploy Postgres with persistence and backup intent — 0/2
- [ ] deploy OpenWebUI through Flux and connect it to Windows-hosted Ollama — 0/2
- [ ] expose OpenWebUI through Gateway/HTTPRoute without exposing Ollama broadly — 0/2

## Observability
- [ ] OTel SDK in FastAPI: traces, metrics, logs (the .py is user-written anyway) — 0/2
- [ ] OTel Collector deployment + pipeline config — 0/2
- [ ] Grafana: build a dashboard — 0/2
- [ ] PromQL basics (MetricsQL is a superset — learn PromQL core first) — 0/2
- [ ] LogsQL (VictoriaLogs) basics — 0/2
- [ ] read a distributed trace in Tempo end-to-end — 0/2

## Model-host boundary
- [ ] document and test Ollama reachability, firewall scope, health checks, and failure behavior — 0/2
- [ ] explain when in-cluster serving would become worthwhile; no GPU passthrough exercise is planned — 0/1

## Disaster drills (after the observability stage — each is a rep)
- [ ] node drain / pod eviction under load — 0/2
- [ ] PVC loss + restore from backup — 0/1
- [ ] broken-sync recovery (bad commit, failed reconcile) — 0/1
- [ ] FINAL BOSS: delete the cluster, rebuild everything from git — 0/1

## Later (triggered work)
- [ ] ESO + secret store (Azure Key Vault or OpenBao) — 0/2
- [ ] provision a real repeatable infrastructure graph with the selected IaC tool — 0/2
- [ ] package Seneschal as a Helm chart and install it into a clean cluster — 0/2
- [ ] Proxmox lab only after a dedicated physical host exists or virtualization becomes the goal — 0/1

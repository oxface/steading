# Infra Training Plan & Tracker

Rule: collaborative area with mastery gate — agent may draft manifests/config for graduated concepts, but **the user executes all setup, install, and debug commands** to build operational feel.

## Learning outcomes (what mastery looks like)

1. Stand up a GitOps-managed k3s cluster from scratch, unaided.
2. Trace the full path git push → CI → registry → Argo sync → running pod, and debug any broken link in it.
3. Diagnose failing workloads fast with kubectl + observability (logs, traces, metrics).
4. Operate the o11y stack as a user: build dashboards, write PromQL/LogQL, read distributed traces.
5. Run GPU workloads on k8s and understand the serving layer well enough to size and tune it.

## Containers
- [ ] Dockerfile for the api (multi-stage, uv) — 0/2
- [ ] Dockerfile for the web (build + static serve) — 0/2
- [ ] docker compose for local dev (postgres + api) — 0/2
- [ ] image/layer mental model, cache-friendly ordering — 0/1

## k3s / Kubernetes core
- [ ] k3s install in WSL2 (`--disable traefik`), kubeconfig/contexts — 0/2
- [ ] Deployment + Service YAML by hand — 0/3
- [ ] Gateway API: install Envoy Gateway; Gateway + HTTPRoute by hand — 0/2
- [ ] ConfigMaps & Secrets — 0/2
- [ ] namespaces, resource requests/limits — 0/2
- [ ] PersistentVolumeClaim (postgres storage) — 0/2
- [ ] kubectl debugging: describe, logs, exec, events — 0/3
- [ ] helm: install a chart, values files, upgrade — 0/2

## GitOps (Flux)
- [ ] Flux bootstrap (Operator + Web UI) — 0/2
- [ ] GitRepository + Kustomization CRs, per-app reconciliation — 0/2
- [ ] Kustomize: base + overlays for own manifests — 0/2
- [ ] HelmRelease for third-party charts via Flux — 0/2
- [ ] drift, suspend/resume, rollback via git revert — 0/2
- [ ] flux CLI diagnostics (`flux get/logs/events/trace`) — 0/2

## Observability
- [ ] OTel SDK in FastAPI: traces, metrics, logs (the .py is user-written anyway) — 0/2
- [ ] OTel Collector deployment + pipeline config — 0/2
- [ ] Grafana: build a dashboard — 0/2
- [ ] PromQL basics (MetricsQL is a superset — learn PromQL core first) — 0/2
- [ ] LogsQL (VictoriaLogs) basics — 0/2
- [ ] read a distributed trace in Tempo end-to-end — 0/2

## AI infra (slice 7+)
- [ ] NVIDIA container toolkit + device plugin in WSL2/k3s — 0/2
- [ ] vLLM deployment, GPU resource requests — 0/2

## Disaster drills (after slice 5 — each is a rep)
- [ ] node drain / pod eviction under load — 0/2
- [ ] PVC loss + restore from backup — 0/1
- [ ] broken-sync recovery (bad commit, failed reconcile) — 0/1
- [ ] FINAL BOSS: delete the cluster, rebuild everything from git — 0/1

## Later (own slices)
- [ ] ESO + secret store (Azure Key Vault or OpenBao) — 0/2
- [ ] Pulumi program (C# or Python) for something real — 0/2
- [ ] Argo CD comparison spike: same app reconciled in a scratch namespace — 0/1

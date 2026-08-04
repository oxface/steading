---
paths:
  - "platform/**"
  - "**/Dockerfile"
  - "**/docker-compose*.{yml,yaml}"
  - "**/compose*.{yml,yaml}"
  - ".github/workflows/**"
---

# Infra area rules

Collaborative area with a mastery gate — check `docs/training/infra.md` before writing manifests/config.

- **The user executes all setup, install, and debug commands personally** (k3s, kubectl, helm, flux, docker) — provide the command with a one-line explanation; never run it yourself. Exception: read-only inspection you need for your own understanding is fine when the user asks you to investigate.
- **Gate on manifests**: draft YAML freely only for graduated concepts; for non-graduated ones, run the guided-rep loop from `docs/training/README.md` — Frame the manifest's purpose and what's deferred, Sample the structure (kinds, key fields, blanks), user writes it, Review, free-text Quiz.
- Architecture invariants: namespace-per-app; platform services (Postgres, o11y, inference) in platform namespaces, never embedded in an app; every app is its own Flux Kustomization; Kustomize for own manifests, HelmRelease for third-party; GitOps is the source of truth — after slice 4, no imperative `kubectl apply` for anything Flux manages.
- Environment: k3s in WSL2 on Windows 11; 16GB VRAM GPU (device plugin from slice 7); ollama on the Windows host until in-cluster vLLM.
- OTel is mandatory for anything deployed: new services ship with traces/metrics/logs wired.
- Propose tracker updates (`docs/training/infra.md`) at session end with user sign-off only.

# Handover: Minimal Seneschal to Thin Steading

Date: August 18, 2026

## Direction now settled

Seneschal remains the product and Steading its first installation and learning environment. The next objective is to get the smallest truthful Seneschal shell into k3s, then introduce Flux before product and platform features accumulate.

Local coding harnesses are optional developer tools. DeepSeek Harness is not a LangGraph competitor in this architecture, and neither Pi nor a local Qwen model becomes a Seneschal dependency. The experiment and its limits are recorded in [Local Coding Agent Evaluation](../local-coding-agent-evaluation.md).

## Current state

- The user-authored FastAPI service exposes `GET /health` with a small JSON response.
- The React app is styled but still says `steading` and displays a hard-coded `api: unknown` state.
- TanStack Query is installed but no `QueryClient` is mounted and no health query exists.
- The repository has substantial uncommitted work. Preserve it; inspect changes before staging anything.
- No training tracker counts were changed. Graduation still requires explicit user sign-off.

## Immediate guided rep: live health shell

This is a user-owned React/TanStack Query rep. It should teach server-state ownership, not merely produce a green indicator.

Build only this behavior:

- Mount one `QueryClient` at the application boundary.
- Query `/api/health` through TanStack Query; do not add manual `fetch` state or an effect.
- Choose and explain `staleTime`, retry, and refetch behavior rather than inheriting them accidentally.
- Render distinct loading, healthy, and unavailable states. Treat the response as untrusted input at the network boundary.
- Replace Steading product branding with Seneschal and remove shell copy that implies unavailable features.
- Leave the API health contract unchanged unless review finds an actual contract problem.

Acceptance evidence supplied by the user:

- Web lint and production build pass.
- API Ruff, Pyright, and tests pass to the extent currently configured.
- With both processes running, the browser visibly transitions to healthy through the Vite `/api` proxy.
- With the API stopped, the browser visibly reaches the unavailable state without an unhandled error.
- The user can explain why TanStack Query owns this state and what events cause a refetch.

Explicitly deferred from this rep: database, auth, agent code, MCP, Ollama calls, integration catalogue, Kubernetes client, generalized design system, and speculative abstractions.

## Delivery sequence after the health rep

1. **Containerize the shell.** The user completes first guided reps for an API image and a production web image, runs the build commands, and proves a local browser-to-API container smoke test.
2. **Create thin Steading.** The user creates the Ubuntu Hyper-V VM, controlled internal/NAT network, single-node k3s install, Windows kubeconfig access, and Traefik Gateway API configuration.
3. **Deploy manually once.** The user writes and applies Seneschal `Deployment`, `Service`, `Gateway`, and `HTTPRoute` resources and proves browser to web to API health. Record what each resource owns and debug the path without Flux hiding it.
4. **Make delivery reproducible.** Add GitHub Actions and GHCR, bootstrap Flux, define Kustomizations, and move the Seneschal shell under reconciliation. From this point Flux is authoritative; do not maintain a second manual deployment path.
5. **Add the first useful workload.** Deploy OpenWebUI through Flux and verify its controlled network path to Windows-hosted Ollama. Add SOPS + age only when the first real secret must be stored in Git, and back up the age private key outside Git.
6. **Build actual Seneschal behavior.** Start with eval questions grounded in the running cluster. Add the integration catalogue and read-only dashboard, then the bounded `seneschal-tools` MCP boundary for Kubernetes and Flux. Perform one raw provider/tool-call implementation before the first LangGraph investigation. Add PostgreSQL/PostgresSaver when actual durable behavior needs it.
7. **Add observability.** Introduce the OTel and Victoria/Grafana/Tempo stack only after Seneschal has a real read-only investigation to observe.

## Learning ownership for upcoming stages

The training trackers make these guided, user-owned reps rather than generated implementation:

- TanStack Query `useQuery`: first rep now.
- API and web Dockerfiles: first reps during containerization.
- Hyper-V networking, k3s installation, kubeconfig, namespaces, `Deployment`, `Service`, probes/resources, Gateway API, and RBAC: first reps in thin Steading.
- Flux bootstrap and Kustomization: first reps immediately after the manual deployment.
- SOPS + age: first rep only when the secret trigger occurs.

Before each stage, re-read the relevant tracker, frame the concept, provide pattern-level examples with meaningful blanks, let the user implement and run commands, review the actual result, then ask the tracker questions. Do not update rep counts without explicit sign-off.

## Next-session starting prompt

> Review my current Seneschal web shell and coach me through the first TanStack Query health-check rep. Keep the scope to correct branding and live `/api/health` states. Give me patterns with meaningful blanks; do not implement it for me. After I make the changes, review the diff and the build/smoke evidence against the handover acceptance criteria.

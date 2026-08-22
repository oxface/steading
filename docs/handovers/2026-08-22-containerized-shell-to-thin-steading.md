# Handover: Containerized Seneschal to Thin Steading

Date: August 22, 2026

## Direction

Seneschal remains the product and Steading its first installation and learning environment. Delivery stages 0 and 1 are complete. The next objective is Stage 2: create the smallest controlled Hyper-V/k3s environment and deploy the existing shell manually exactly once before Flux becomes authoritative.

## Completed local shell

- The user-authored FastAPI service exposes `GET /health`.
- The React SPA is branded Seneschal and owns API health as TanStack Query server state.
- The network response is runtime-validated before use and the UI renders distinct loading, healthy, and unavailable states.
- Query behavior deliberately uses a 40-second `staleTime`; focus after that interval can trigger a refetch.
- API and web checks pass.
- Separate production-shaped API and web images build with Podman.
- A two-container smoke test proved browser to nginx to FastAPI health. Docker Compose was removed because it was not needed as a second local orchestrator.

## Aspire local development

- `aspire-apphost/apphost.mts` runs the FastAPI application through `addUvicornApp`/uv and the SPA through `addViteApp`/pnpm.
- The web resource receives the API endpoint through `SENESCHAL_API_URL`; Vite uses it as the `/api` proxy target.
- Fixed public ports make orphaned processes visible: web is `http://localhost:5173`; the Aspire-proxied API is `https://localhost:8000`.
- The Vite endpoint is updated directly with `withHttpEndpoint({ port: 5173 })`.
- Root and web tooling use pnpm. The isolated AppHost uses npm because Aspire 13.5's `pnpm install --ignore-workspace` is incompatible with pnpm 11's project-scoped `allowBuilds` policy for `esbuild`.
- AppHost lint, TypeScript build, startup, health behavior, stop, and restart were all tested successfully.

## Training state

- TanStack Query `useQuery`: 1/3 guided.
- API Dockerfile: 1/2 guided.
- Web Dockerfile: 1/2 guided.
- Image/layer mental model: graduated.
- No tracker item exists for Aspire AppHost wiring, so the successful Aspire acceptance test does not change a tracker count.

## Stage 2 progress

- A Generation 2 Ubuntu 26.04 VM named `steading-cluster` runs on the Hyper-V Default Switch.
- Windows reaches it through the stable `steading-cluster.mshome.net` endpoint while Hyper-V owns the DHCP address, NAT, and DNS behavior.
- SSH uses the general workstation key through the local `steading` host alias.
- VM DNS and outbound HTTPS were verified.
- Single-node k3s `v1.36.3+k3s1` is installed; the node is ready and CoreDNS, metrics-server, local-path provisioning, ServiceLB, and Traefik are healthy.
- Windows-to-API access was proven once, including the hostname TLS SAN, then the copied `system:admin` kubeconfig was removed from Windows.
- The unrestricted kubeconfig remains root-only on the VM. SSH is reserved for bootstrap and break-glass administration; after Flux bootstrap, Git becomes the routine write path.
- These are completed operational steps, not tracker count changes; the guided-rep review and explicit sign-off still apply.

## Immediate Stage 2 guided rep

Enable and verify Gateway API support in the bundled Traefik installation. The rep should establish:

1. The distinction between installing Gateway API CRDs and enabling a controller's Gateway provider.
2. Which Traefik Helm configuration k3s persists across restarts and upgrades.
3. How to prove the controller advertises and accepts the intended Gateway API resources before deploying Seneschal.

Run cluster administration through `ssh steading` and root-local `sudo k3s kubectl`; do not recreate or export an administrator kubeconfig to Windows. The manual Seneschal deployment still happens exactly once for learning, then Flux replaces imperative application changes.

## Stage 2 sequence

1. Completed: create, size, and validate the Generation 2 Ubuntu VM.
2. Completed: accept the managed Hyper-V Default Switch behind a stable hostname; defer custom NAT unless Ollama reachability proves the trigger.
3. Completed: install healthy single-node k3s and keep cluster-admin credentials root-local.
4. Enable and verify k3s-bundled Traefik Gateway API support.
5. Hand-write and manually apply Seneschal namespace, Deployments, Services, Gateway, and HTTPRoutes exactly once through SSH-local administration.
6. Prove browser → Gateway → web → API health and practice `kubectl describe`, logs, events, and exec while the topology is still small.
7. Move immediately to Stage 3: image publishing and Flux reconciliation. Do not preserve manual apply as a parallel delivery path.
8. Verify the controlled VM → Windows Ollama path before OpenWebUI depends on it; introduce custom NAT only if the Default Switch cannot provide a stable, appropriately scoped endpoint.

## Still deferred

Database, authentication, LangGraph, MCP, Ollama integration in Seneschal, OpenWebUI, Flux, SOPS, and the observability stack remain deferred until their roadmap stages or triggers.

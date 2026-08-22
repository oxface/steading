# Handover: Containerized Seneschal to Thin Steading

Date: August 22, 2026

## Direction

Seneschal remains the product and Steading its first installation and learning environment. Delivery stages 0 and 1 are complete. Stage 2 now establishes the smallest controlled Hyper-V/k3s environment and makes Flux authoritative before application workloads are deployed.

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
- The unrestricted kubeconfig remains root-only on the VM. SSH is reserved for bootstrap and break-glass administration; Git is now the routine write path.
- Traefik's Gateway API provider is enabled and its `GatewayClass` is accepted.
- Flux `v2.9.4` is bootstrapped from `platform/clusters/local` with healthy controllers and a read-only GitHub deploy key.
- The local networking Namespace, Gateway, Kustomize unit, and Flux reconciliation object are committed. Their live reconciliation is the next verification point.
- `platform/bootstrap/local` captures the proven clean-VM path with pinned k3s and Flux versions, staged scripts, interactive credentials, and an end-to-end verifier.
- These are completed operational steps, not tracker count changes; the guided-rep review and explicit sign-off still apply.

## Immediate next increment

Verify the networking reconciliation, then deliver Seneschal through GitHub Actions, GHCR, and Flux. The increment should establish:

1. The distinction between the bootstrap `flux-system` reconciliation and the independently reconciled `networking` unit.
2. The image boundary: CI publishes immutable images; Flux deploys references to them.
3. Namespace, Deployment, Service, and HTTPRoute behavior without giving Windows a cluster-admin kubeconfig.

Run diagnostics through `ssh steading` and root-local `sudo k3s kubectl`; do not recreate or export an administrator kubeconfig to Windows. Change Flux-owned resources only through Git.

## Stage 2 sequence

1. Completed: create, size, and validate the Generation 2 Ubuntu VM.
2. Completed: accept the managed Hyper-V Default Switch behind a stable hostname; defer custom NAT unless Ollama reachability proves the trigger.
3. Completed: install healthy single-node k3s and keep cluster-admin credentials root-local.
4. Completed: enable and verify k3s-bundled Traefik Gateway API support.
5. Completed: bootstrap healthy Flux controllers and make `platform/clusters/local` authoritative.
6. Verify the Flux-managed networking Namespace and Gateway.
7. Publish Seneschal images to GHCR and add its Namespace, Deployments, Services, and HTTPRoute through Flux.
8. Prove browser → Gateway → web → API health and practice `kubectl describe`, logs, events, and exec while the topology is still small.
9. Verify the controlled VM → Windows Ollama path before OpenWebUI depends on it; introduce custom NAT only if the Default Switch cannot provide a stable, appropriately scoped endpoint.

## Still deferred

Database, authentication, LangGraph, MCP, Ollama integration in Seneschal, OpenWebUI, SOPS, and the observability stack remain deferred until their roadmap stages or triggers.

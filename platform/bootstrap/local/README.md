# Local cluster bootstrap

These scripts reproduce the cluster substrate on a clean Ubuntu VM. They stop
at the GitOps boundary: k3s, the bundled Traefik controller configuration, and
Flux are bootstrapped imperatively; namespaces, Gateways, and workloads are
reconciled from Git.

## Preconditions

- A clean Ubuntu VM attached to the `Steading` Hyper-V internal switch, with
  `192.168.50.10/24`, gateway `192.168.50.1`, outbound HTTPS, and working DNS.
- The VM is reachable through the local SSH alias `steading`.
- The Windows hosts file maps `steading-cluster.steading.test` and the local
  application hostnames to `192.168.50.10`.
- Windows uses `192.168.50.1/24` on the internal switch, owns `SteadingNAT` for
  `192.168.50.0/24`, and allows only the VM address to reach Ollama on TCP
  `11434`.
- The `main` branch contains `platform/clusters/local` and the desired cluster
  resources.
- A fine-grained GitHub PAT is available for the interactive Flux bootstrap.
  Scope it only to `oxface/steading` with repository `Administration: read and
  write`, `Contents: read and write`, and `Metadata: read-only`. Do not pass the
  token on the command line or store it on the VM.

The scripts pin the k3s and Flux versions in `versions.env`. A version change is
a reviewed repository change, not an automatic upgrade during VM bootstrap.

## Copy to a clean VM

From PowerShell at the repository root:

```powershell
ssh steading "mkdir -p /tmp/steading-bootstrap"
scp -r .\platform\bootstrap\local\* steading:/tmp/steading-bootstrap/
```

The bootstrap does not require cloning the repository onto the VM. Flux obtains
the cluster state directly from GitHub after its deploy key is configured.

## Run the complete bootstrap

```powershell
ssh steading
```

Then on the VM:

```bash
sudo bash /tmp/steading-bootstrap/bootstrap.sh
```

The Flux step prompts for the PAT without echoing it. The command uses
`--token-auth=false`, so the PAT is not stored in Kubernetes. GitHub receives a
read-only deploy key and its private key remains in the `flux-system` Secret.
GitHub links a deploy key created this way to the PAT that created it, so keep
the PAT valid and rotate/re-bootstrap the deploy key before the PAT expires.

The scripts are safe to rerun when the installed versions and Flux source match
the repository configuration. They stop instead of silently changing an
unexpected k3s version or an existing Flux source/path.

## Run or diagnose one stage

Each stage can be run independently:

```bash
sudo bash /tmp/steading-bootstrap/install-k3s.sh
sudo bash /tmp/steading-bootstrap/configure-traefik.sh
sudo bash /tmp/steading-bootstrap/bootstrap-flux.sh
sudo bash /tmp/steading-bootstrap/verify.sh
```

Supported overrides describe a different cluster; they do not contain secrets:

```bash
sudo env CLUSTER_HOSTNAME=steading-cluster.steading.test CLUSTER_NODE_IP=192.168.50.10 GITHUB_OWNER=oxface GITHUB_REPOSITORY=steading GIT_BRANCH=main FLUX_PATH=platform/clusters/local bash /tmp/steading-bootstrap/bootstrap.sh
```

## Ownership boundary

- `install-k3s.sh` owns the k3s service installation and root-only kubeconfig.
- `configure-traefik.sh` owns the root-local k3s `HelmChartConfig` needed to
  enable Traefik's Gateway API provider.
- `bootstrap-flux.sh` owns only the initial controller/deploy-key bootstrap.
- Flux owns everything referenced below `platform/clusters/local`.
- `verify.sh` is read-only and can be used over break-glass SSH.

Do not add `kubectl apply` commands for application or platform resources to
these scripts. Those changes belong in Git after Flux is healthy.

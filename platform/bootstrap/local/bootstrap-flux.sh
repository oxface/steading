#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=versions.env
source "${SCRIPT_DIR}/versions.env"

readonly GITHUB_OWNER="${GITHUB_OWNER:-oxface}"
readonly GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-steading}"
readonly GIT_BRANCH="${GIT_BRANCH:-main}"
readonly FLUX_PATH="${FLUX_PATH:-platform/clusters/local}"
readonly KUBECONFIG_PATH="/etc/rancher/k3s/k3s.yaml"
readonly EXPECTED_SOURCE_URL="ssh://git@github.com/${GITHUB_OWNER}/${GITHUB_REPOSITORY}"

if (( EUID != 0 )); then
  echo "Run this script as root: sudo bash $0" >&2
  exit 1
fi

if ! systemctl is-active --quiet k3s; then
  echo "k3s is not running; run install-k3s.sh first." >&2
  exit 1
fi

install_flux_cli() (
  local architecture archive checksum download_url installed_version temporary_directory

  installed_version=""
  if command -v flux >/dev/null 2>&1; then
    installed_version="$(flux --version | sed -E 's/^flux version //')"
  fi

  if [[ "${installed_version}" == "${FLUX_VERSION}" ]]; then
    echo "Flux CLI ${FLUX_VERSION} is already installed."
    return
  fi

  case "$(uname -m)" in
    x86_64)
      architecture="amd64"
      checksum="${FLUX_LINUX_AMD64_SHA256}"
      ;;
    aarch64 | arm64)
      architecture="arm64"
      checksum="${FLUX_LINUX_ARM64_SHA256}"
      ;;
    *)
      echo "Unsupported architecture: $(uname -m)" >&2
      exit 1
      ;;
  esac

  temporary_directory="$(mktemp -d)"
  archive="${temporary_directory}/flux.tar.gz"
  download_url="https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_${architecture}.tar.gz"

  cleanup_flux_download() {
    rm -rf -- "${temporary_directory}"
  }
  trap cleanup_flux_download EXIT

  curl \
    --proto '=https' \
    --tlsv1.2 \
    --fail \
    --silent \
    --show-error \
    --location \
    "${download_url}" \
    --output "${archive}"

  printf '%s  %s\n' "${checksum}" "${archive}" | sha256sum --check --status
  tar --extract --gzip --file "${archive}" --directory "${temporary_directory}" flux
  install --mode=0755 "${temporary_directory}/flux" /usr/local/bin/flux

  echo "Installed Flux CLI ${FLUX_VERSION}."
)

install_flux_cli
flux --version

if k3s kubectl get gitrepository/flux-system --namespace=flux-system >/dev/null 2>&1; then
  current_url="$(k3s kubectl get gitrepository/flux-system --namespace=flux-system --output=jsonpath='{.spec.url}')"
  current_path="$(k3s kubectl get kustomization/flux-system --namespace=flux-system --output=jsonpath='{.spec.path}')"

  if [[ "${current_url}" != "${EXPECTED_SOURCE_URL}" || "${current_path}" != "./${FLUX_PATH}" ]]; then
    echo "Flux is already bootstrapped with unexpected source configuration." >&2
    echo "Expected URL: ${EXPECTED_SOURCE_URL}" >&2
    echo "Actual URL:   ${current_url}" >&2
    echo "Expected path: ./${FLUX_PATH}" >&2
    echo "Actual path:   ${current_path}" >&2
    exit 1
  fi

  echo "Flux is already bootstrapped for ${EXPECTED_SOURCE_URL} at ./${FLUX_PATH}."
  flux check --kubeconfig="${KUBECONFIG_PATH}"
  exit 0
fi

flux check --pre --kubeconfig="${KUBECONFIG_PATH}"

# Force an interactive prompt. A token must never be inherited accidentally or
# written into this script. With token-auth=false, the cluster receives a
# repository-scoped SSH deploy key rather than the PAT.
unset GITHUB_TOKEN

flux bootstrap github \
  --kubeconfig="${KUBECONFIG_PATH}" \
  --owner="${GITHUB_OWNER}" \
  --repository="${GITHUB_REPOSITORY}" \
  --branch="${GIT_BRANCH}" \
  --path="${FLUX_PATH}" \
  --personal \
  --token-auth=false \
  --network-policy=true

flux check --kubeconfig="${KUBECONFIG_PATH}"

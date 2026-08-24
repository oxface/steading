#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=versions.env
source "${SCRIPT_DIR}/versions.env"

readonly CLUSTER_HOSTNAME="${CLUSTER_HOSTNAME:-steading-cluster.steading.test}"
readonly CLUSTER_NODE_IP="${CLUSTER_NODE_IP:-192.168.50.10}"
readonly KUBECONFIG_PATH="/etc/rancher/k3s/k3s.yaml"

if (( EUID != 0 )); then
  echo "Run this script as root: sudo bash $0" >&2
  exit 1
fi

if command -v k3s >/dev/null 2>&1; then
  installed_version="$(k3s --version | awk 'NR == 1 { print $3 }')"
  if [[ "${installed_version}" != "${K3S_VERSION}" ]]; then
    echo "k3s ${installed_version} is already installed; expected ${K3S_VERSION}." >&2
    echo "Upgrade and downgrade behavior must be reviewed explicitly." >&2
    exit 1
  fi

  echo "k3s ${K3S_VERSION} is already installed."
  systemctl enable --now k3s
else
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install --yes ca-certificates curl

  installer="$(mktemp)"
  cleanup() {
    rm -f -- "${installer}"
  }
  trap cleanup EXIT

  curl \
    --proto '=https' \
    --tlsv1.2 \
    --fail \
    --silent \
    --show-error \
    --location \
    https://get.k3s.io \
    --output "${installer}"

  INSTALL_K3S_VERSION="${K3S_VERSION}" \
    sh "${installer}" server \
      --node-ip "${CLUSTER_NODE_IP}" \
      --advertise-address "${CLUSTER_NODE_IP}" \
      --tls-san "${CLUSTER_HOSTNAME}"
fi

chmod 600 "${KUBECONFIG_PATH}"
k3s kubectl wait node --all --for=condition=Ready --timeout=5m
k3s --version

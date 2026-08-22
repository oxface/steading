#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if (( EUID != 0 )); then
  echo "Run this script as root: sudo bash $0" >&2
  exit 1
fi

echo "[1/4] Installing k3s"
bash "${SCRIPT_DIR}/install-k3s.sh"

echo "[2/4] Configuring the bundled Traefik installation"
bash "${SCRIPT_DIR}/configure-traefik.sh"

echo "[3/4] Installing and bootstrapping Flux"
bash "${SCRIPT_DIR}/bootstrap-flux.sh"

echo "[4/4] Verifying the reconciled cluster"
bash "${SCRIPT_DIR}/verify.sh"

echo "Steading local-cluster bootstrap completed successfully."

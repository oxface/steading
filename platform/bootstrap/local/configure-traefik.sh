#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly SOURCE_MANIFEST="${SCRIPT_DIR}/manifests/k3s-traefik-config.yaml"
readonly TARGET_MANIFEST="/var/lib/rancher/k3s/server/manifests/k3s-traefik-config.yaml"

if (( EUID != 0 )); then
  echo "Run this script as root: sudo bash $0" >&2
  exit 1
fi

if ! systemctl is-active --quiet k3s; then
  echo "k3s is not running; run install-k3s.sh first." >&2
  exit 1
fi

if [[ ! -f "${SOURCE_MANIFEST}" ]]; then
  echo "Missing source manifest: ${SOURCE_MANIFEST}" >&2
  exit 1
fi

if [[ -f "${TARGET_MANIFEST}" ]] && cmp --silent "${SOURCE_MANIFEST}" "${TARGET_MANIFEST}"; then
  echo "Traefik Gateway API configuration is already current."
else
  install --directory --mode=0755 "$(dirname -- "${TARGET_MANIFEST}")"
  install --mode=0644 "${SOURCE_MANIFEST}" "${TARGET_MANIFEST}"
  echo "Installed Traefik Gateway API configuration."
fi

k3s kubectl rollout status deployment/traefik --namespace=kube-system --timeout=5m

for _ in {1..60}; do
  if k3s kubectl get gatewayclass/traefik >/dev/null 2>&1; then
    break
  fi
  sleep 5
done

if ! k3s kubectl get gatewayclass/traefik >/dev/null 2>&1; then
  echo "Traefik did not create GatewayClass/traefik within five minutes." >&2
  exit 1
fi

k3s kubectl wait gatewayclass/traefik \
  --for=jsonpath='{.status.conditions[?(@.type=="Accepted")].status}'=True \
  --timeout=5m

k3s kubectl get gatewayclass traefik

#!/usr/bin/env bash

set -Eeuo pipefail

readonly KUBECONFIG_PATH="/etc/rancher/k3s/k3s.yaml"

if (( EUID != 0 )); then
  echo "Run this script as root: sudo bash $0" >&2
  exit 1
fi

wait_for_resource() {
  local description="$1"
  shift

  for _ in {1..60}; do
    if "$@" >/dev/null 2>&1; then
      return
    fi
    sleep 5
  done

  echo "Timed out waiting for ${description} to exist." >&2
  exit 1
}

systemctl is-active --quiet k3s
k3s kubectl wait node --all --for=condition=Ready --timeout=5m
k3s kubectl rollout status deployment/coredns --namespace=kube-system --timeout=5m
k3s kubectl rollout status deployment/local-path-provisioner --namespace=kube-system --timeout=5m
k3s kubectl rollout status deployment/metrics-server --namespace=kube-system --timeout=5m
k3s kubectl rollout status deployment/traefik --namespace=kube-system --timeout=5m

k3s kubectl wait gatewayclass/traefik \
  --for=jsonpath='{.status.conditions[?(@.type=="Accepted")].status}'=True \
  --timeout=5m

flux check --kubeconfig="${KUBECONFIG_PATH}"
wait_for_resource "Flux Kustomization/networking" \
  k3s kubectl get kustomization/networking --namespace=flux-system
k3s kubectl wait kustomization/flux-system --namespace=flux-system \
  --for=condition=Ready --timeout=5m
k3s kubectl wait kustomization/networking --namespace=flux-system \
  --for=condition=Ready --timeout=5m
wait_for_resource "Gateway networking/public" \
  k3s kubectl get gateway/public --namespace=networking
k3s kubectl wait gateway/public --namespace=networking \
  --for=jsonpath='{.status.conditions[?(@.type=="Programmed")].status}'=True \
  --timeout=5m

echo
flux get sources git --all-namespaces --kubeconfig="${KUBECONFIG_PATH}"
echo
flux get kustomizations --all-namespaces --kubeconfig="${KUBECONFIG_PATH}"
echo
k3s kubectl get gatewayclass traefik
k3s kubectl get gateway public --namespace=networking --output=wide

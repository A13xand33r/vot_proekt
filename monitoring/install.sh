#!/bin/bash
set -euo pipefail

# Installs Prometheus + Grafana (kube-prometheus-stack) and Loki in the
# `monitoring` namespace of the current kubectl context (minikube by default).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Adding Helm repos"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "==> Creating monitoring namespace"
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "==> Installing kube-prometheus-stack"
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  -f "${SCRIPT_DIR}/prometheus-values.yaml" \
  --namespace monitoring

echo "==> Installing Loki stack"
helm upgrade --install loki grafana/loki-stack \
  --namespace monitoring \
  --set promtail.enabled=true,grafana.enabled=false

echo
echo "Done. Access Grafana with:"
echo "  minikube service -n monitoring monitoring-grafana"
echo "Default credentials: admin / admin123"

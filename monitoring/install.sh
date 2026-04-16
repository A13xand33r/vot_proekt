#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  -f "${SCRIPT_DIR}/prometheus-values.yaml" \
  --namespace monitoring

helm upgrade --install loki grafana/loki-stack \
  --namespace monitoring \
  --set promtail.enabled=true,grafana.enabled=false

echo "Done. Grafana: minikube service -n monitoring monitoring-grafana (admin/admin123)"

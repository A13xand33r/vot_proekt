# Архитектура

```
Developer -> GitHub -> GitHub Actions (test + build) -> Docker Hub
                                                            |
ArgoCD  <-- watches k8s/ dir                                |
  |                                                    pull image
  v                                                         |
Kubernetes (minikube)  <------------------------------------+
  |
  +-- Deployment (2 replicas)
  +-- Service (NodePort)
  +-- Secret
  |
Prometheus + Grafana  <-- scrape metrics
Loki                  <-- collect logs
Alertmanager          --> Discord webhook
```

## Secrets

- GitHub Secrets: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, DISCORD_WEBHOOK
- Kubernetes Secret: app-secrets (runtime env vars)
- secret.yaml е в .gitignore, има само secret.example.yaml като template

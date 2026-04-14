# Архитектурна диаграма

## Компоненти

```
+-----------------+      git push       +------------------+
|   Developer     +-------------------->+    GitHub Repo   |
|  (IDE + git)    |                     |                  |
+-----------------+                     +--------+---------+
                                                 |
                                                 | webhook
                                                 v
                                      +----------+----------+
                                      |  GitHub Actions CI  |
                                      |  - flake8           |
                                      |  - pytest           |
                                      |  - docker build     |
                                      |  - docker push      |
                                      +----------+----------+
                                                 |
                                                 v
                                         +-------+--------+
                                         |  Docker Hub    |
                                         +-------+--------+
                                                 |
                                                 | pull image
                                                 v
+---------------------+               +----------+-----------+
|   ArgoCD (GitOps)   +-------------->+   Kubernetes         |
|  watches k8s/ dir   |  kubectl      |   (minikube)         |
+---------------------+  apply        |                      |
                                      |  Deployment (x2)     |
                                      |  Service (NodePort)  |
                                      |  Secret              |
                                      +----------+-----------+
                                                 |
                                      scrape     |     logs
                            +--------------------+--------------------+
                            v                                         v
                 +----------+----------+                   +----------+---------+
                 | Prometheus + Grafana|                   |       Loki         |
                 | kube-prometheus-stack|                  +----------+---------+
                 +----------+----------+
                            |
                            v
                 +----------+----------+
                 |   Alertmanager      |
                 |   -> Discord webhook|
                 +---------------------+
```

## Инфраструктурна диаграма

- **Компютър разработчик**: Linux/Windows с Docker Desktop, kubectl, minikube, Terraform, git, pre-commit.
- **GitHub**: съхранение на код, GitHub Actions runners, GitHub Secrets (DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, DISCORD_WEBHOOK).
- **Docker Hub**: registry за `alexander75977/devops-app` образи.
- **Kubernetes клъстер (minikube локално)**:
  - `devops-app` namespace: Deployment (2 replicas) + Service (NodePort) + Secret (`app-secrets`).
  - `argocd` namespace: ArgoCD контроли.
  - `monitoring` namespace: kube-prometheus-stack (Prometheus, Grafana, Alertmanager), Loki.
- **External**: Discord webhook за нотификации от Alertmanager и CI.

## Secrets flow

1. GitHub Secrets съхранява Docker Hub credentials и Discord webhook за CI.
2. Kubernetes Secret `app-secrets` съхранява runtime secrets, инжектирани в Deployment-а през `env.valueFrom.secretKeyRef`.
3. `k8s/secret.example.yaml` е шаблон без истински стойности; реалният `secret.yaml` е в `.gitignore` и се създава ръчно или чрез `kubectl create secret`.

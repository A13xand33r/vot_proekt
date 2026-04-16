# DevOps Todo App

Просто todo приложение с Flask, контейнеризирано с Docker и деплойнато в Kubernetes чрез ArgoCD. Включва CI/CD pipeline, monitoring и IaC.

## Архитектура

![Architecture](docs/architecture.png)

```
Developer -> GitHub -> GitHub Actions (test + build) -> Docker Hub
ArgoCD -> sync k8s/ -> Kubernetes (minikube)
Prometheus + Grafana + Loki -> Alertmanager -> Discord
```

## Технологии

- Python 3.11 / Flask 3.0
- Docker
- Kubernetes (minikube)
- GitHub Actions (CI)
- ArgoCD (CD)
- Terraform (IaC)
- Prometheus, Grafana, Loki (monitoring)
- pre-commit + gitleaks

## Стартиране

```bash
# локално
pip install -r app/requirements.txt
python app/app.py

# docker
docker build -t devops-app .
docker run -p 5000:5000 devops-app

# kubernetes
minikube start
kubectl create secret generic app-secrets --from-literal=secret-key=mysecret
kubectl apply -f k8s/deployment.yaml -f k8s/service.yaml
minikube service devops-app-service

# terraform
cd terraform && terraform init && terraform apply

# monitoring
bash monitoring/install.sh
```

## API

- `GET /health` - healthcheck
- `GET /tasks` - всички задачи
- `POST /tasks` - нова задача (`{"title": "..."}`)
- `DELETE /tasks/<id>` - изтриване
- `GET /metrics` - prometheus метрики

## Структура

```
├── app/                 # приложение
├── tests/               # тестове
├── k8s/                 # kubernetes manifests
├── terraform/           # IaC
├── monitoring/          # prometheus/grafana/loki
├── .github/workflows/   # CI pipeline
├── docs/                # документация
└── Dockerfile
```

## Автори

- Ivan Genov
- Alexander Asenov

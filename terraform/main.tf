terraform {
  required_version = ">= 1.6.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "devops-app"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = { app = "devops-app" }
    }

    template {
      metadata {
        labels = { app = "devops-app" }
      }
      spec {
        container {
          name  = "devops-app"
          image = "${var.image_repo}:${var.image_tag}"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "devops-app-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = { app = "devops-app" }
    port {
      port        = 80
      target_port = 5000
    }
    type = "NodePort"
  }
}

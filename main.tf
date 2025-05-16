# Configurar el proveedor de Kubernetes
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

provider "kubernetes" {
  # Usar el kubeconfig de Minikube
  config_path = "~/.kube/config"
}

# Crear un despliegue de Nginx
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deploy"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx-container"
        }
      }
    }
  }
}

# Crear un servicio para exponer Nginx
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

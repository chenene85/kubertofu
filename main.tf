terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      # Asegúrate de que la versión sea compatible. Puedes ver la que usas en tu `tofu init`
      # Por tu captura anterior, parece que usas v2.23.0
      version = "~> 2.23.0"
    }
  }
}

# No es necesario un bloque provider "kubernetes" { ... } explícito con host, certs, etc.
# si KUBECONFIG está bien configurado y se pasa como variable de entorno.
# OpenTofu lo usará automáticamente.

# Ejemplo de un recurso (esto dependerá de lo que quieras desplegar)
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deploy"
    labels = {
      App = "Nginx"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "Nginx"
      }
    }
    template {
      metadata {
        labels = {
          App = "Nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = {
      # Esta línea tiene una referencia que podría ser más robusta, pero no causa el error de conexión
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata.0.labels.App
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer" # O NodePort, ClusterIP según necesites
  }
}

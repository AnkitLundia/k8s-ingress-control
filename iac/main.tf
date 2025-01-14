terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}
data "kubernetes_namespace" "test" {
  metadata {
    name = "default"
  }
}

locals {
  deployment_config = jsondecode(file("deployments.json"))
  deployment_list = [for dep in local.deployment_config["applications"] : dep]
}

resource "kubernetes_deployment" "deployment_config" {
  for_each = {for dep in local.deployment_list : dep["name"] => dep}
  metadata {
    name      = each.value["name"]
    namespace = data.kubernetes_namespace.test.metadata.0.name
  }
  spec {
    replicas = each.value["replicas"]
    selector {
      match_labels = {
        app = each.value["name"]
      }
    }
    template {
      metadata {
        labels = {
          app = each.value["name"]
        }
      }
      spec {
        container {
          image = each.value["image"] 
          name  = each.value["name"]
          args = split(",", each.value["args"])
          port {
            container_port = each.value["port"]
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service_config" {
  for_each = {for dep in local.deployment_list : dep["name"] => dep}
  metadata {
    name      = each.value["name"]
    namespace = data.kubernetes_namespace.test.metadata.0.name
  }
  spec {
    selector = {
      app = each.value["name"]
    }
    type = "NodePort"
    port {
      port        = each.value["port"]
      target_port = each.value["port"]
    }
  }
}

resource "kubernetes_ingress_v1" "ingress_config" {
  for_each = {for dep in local.deployment_list : dep["name"] => dep}
  metadata {
    name = each.value["name"]
    annotations = each.value["name"] == element(local.deployment_list, length(local.deployment_list) - 1)["name"] ? {} :{
      "nginx.ingress.kubernetes.io/canary" = "true"
      "nginx.ingress.kubernetes.io/canary-weight" = each.value["traffic_weight"]  
      "nginx.ingress.kubernetes.io/upstream-hash-by" = "$request_id"
      "nginx.ingress.kubernetes.io/affinity-canary-behavior" = "legacy"
    }
    namespace = data.kubernetes_namespace.test.metadata.0.name
    
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "assignment.demo"
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = each.value["name"]
              port {
                number = each.value["port"]
              }
            }
          }
        }
      }
    }
  }
}
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

resource "kubernetes_secret_v1" "serviceaccount" {
  metadata {
    name      = "cluster-autoscaler"
    labels    = {
        k8s-addon = "cluster-autoscaler.addons.k8s.io"
        k8s-app   = "cluster-autoscaler"
    }
    namespace = "kube-system"

  }
}
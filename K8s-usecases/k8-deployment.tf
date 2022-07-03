# Access Key ID: AKIAVPL27FZXW2CCGVMZ
# Secret Access Key: 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
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
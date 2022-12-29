# Configure Kubernetes provider and connect to the Kubernetes API server

terraform {
  required_version = ">= 0.13"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
 }
 
provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

data "kubectl_file_documents" "namespace" {
    content = file("${path.cwd}/manifests/argocd/namespace.yml")
} 
data "kubectl_file_documents" "argocd" {
    content = file("${path.cwd}/manifests/argocd/install.yml")
}

resource "kubectl_manifest" "namespace" {
    count     = length(data.kubectl_file_documents.namespace.documents)
    yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
    override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
    depends_on = [
      kubectl_manifest.namespace,
    ]
    count     = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"
}





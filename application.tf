data "kubectl_file_documents" "sdapp" {
    content = file("${path.cwd}/manifests/argocd/application.yaml")
}

resource "kubectl_manifest" "sdapp" {
    depends_on = [
      kubectl_manifest.argocd,
    ]
    count     = length(data.kubectl_file_documents.sdapp.documents)
    yaml_body = element(data.kubectl_file_documents.sdapp.documents, count.index)
    override_namespace = "argocd"
}
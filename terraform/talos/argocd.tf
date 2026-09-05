

resource "kubernetes_namespace" "argocd" {
  depends_on = [talos_cluster_kubeconfig.this]

  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "10.7.1"

  values = [
    templatefile("${path.module}/argocd-values.yaml", {
      github_username            = local.github_username
      github_token               = local.github_token
      github_oauth_client_id     = local.github_oauth_client_id
      github_oauth_client_secret = local.github_oauth_client_secret
      chartmuseum_username       = local.chartmuseum_username
      chartmuseum_password       = local.chartmuseum_password
    })
  ]
}

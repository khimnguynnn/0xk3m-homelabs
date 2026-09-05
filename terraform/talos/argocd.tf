data "vault_kv_secret_v2" "chartmuseum" {
  mount = "secret"
  name  = "platform/chartmuseum"
}

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
      github_username            = var.github_username
      github_token               = var.github_token
      github_oauth_client_id     = var.github_oauth_client_id
      github_oauth_client_secret = var.github_oauth_client_secret
      chartmuseum_username       = data.vault_kv_secret_v2.chartmuseum.data["user"]
      chartmuseum_password       = data.vault_kv_secret_v2.chartmuseum.data["password"]
    })
  ]
}

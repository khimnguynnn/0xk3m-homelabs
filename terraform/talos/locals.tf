locals {
  argocd_admin_password      = data.vault_kv_secret_v2.talos.data["argocd_admin_password"]
  cluster_endpoint           = data.vault_kv_secret_v2.talos.data["cluster_endpoint"]
  github_oauth_client_id     = data.vault_kv_secret_v2.talos.data["github_oauth_client_id"]
  github_oauth_client_secret = data.vault_kv_secret_v2.talos.data["github_oauth_client_secret"]
  github_token               = data.vault_kv_secret_v2.talos.data["github_token"]
  github_username            = data.vault_kv_secret_v2.talos.data["github_username"]
  chartmuseum_username       = data.vault_kv_secret_v2.chartmuseum.data["user"]
  chartmuseum_password       = data.vault_kv_secret_v2.chartmuseum.data["password"]
}

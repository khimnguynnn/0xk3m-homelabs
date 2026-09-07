locals {
  argocd_admin_password      = data.vault_kv_secret_v2.talos.data["argocd_admin_password"]
  cluster_endpoint           = data.vault_kv_secret_v2.talos.data["cluster_endpoint"]
  google_oauth_client_id     = data.vault_kv_secret_v2.talos.data["google_oauth_client_id"]
  google_oauth_client_secret = data.vault_kv_secret_v2.talos.data["google_oauth_client_secret"]
  github_token               = data.vault_kv_secret_v2.talos.data["github_token"]
  github_username            = data.vault_kv_secret_v2.talos.data["github_username"]
  chartmuseum_username       = data.vault_kv_secret_v2.talos.data["chartmuseum_user"]
  chartmuseum_password       = data.vault_kv_secret_v2.talos.data["chartmuseum_passwd"]
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = var.path
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = var.kubernetes_host
}

resource "vault_kubernetes_auth_backend_role" "this" {
  for_each                         = var.roles
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = each.key
  bound_service_account_names      = each.value.service_accounts
  bound_service_account_namespaces = each.value.namespaces
  token_policies                   = each.value.policies
  token_ttl                        = each.value.token_ttl
}

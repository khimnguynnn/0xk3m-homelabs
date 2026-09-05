data "vault_kv_secret_v2" "talos" {
  mount = "secret"
  name  = "terraform/talos"
}

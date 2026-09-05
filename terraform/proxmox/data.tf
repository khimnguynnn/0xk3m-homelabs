data "vault_kv_secret_v2" "proxmox" {
  mount = "secret"
  name  = "terraform/proxmox"
}

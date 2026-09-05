locals {
  proxmox_endpoint  = data.vault_kv_secret_v2.proxmox.data["proxmox_endpoint"]
  proxmox_api_token = data.vault_kv_secret_v2.proxmox.data["proxmox_api_token"]
}

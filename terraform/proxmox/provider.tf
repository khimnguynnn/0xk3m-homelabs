provider "proxmox" {
  endpoint  = local.proxmox_endpoint
  api_token = local.proxmox_api_token
  insecure  = var.proxmox_insecure
}

provider "vault" {
  address          = "http://vault.0xk3m.dev"
  skip_child_token = true
}

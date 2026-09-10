provider "proxmox" {
  endpoint  = local.proxmox_endpoint
  api_token = local.proxmox_api_token
  insecure  = var.proxmox_insecure
}

provider "vault" {
  address          = "http://vault.platform.svc.cluster.local:8200"
  skip_child_token = true
  skip_tls_verify  = true
}

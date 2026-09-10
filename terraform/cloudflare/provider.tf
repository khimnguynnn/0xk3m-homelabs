provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

provider "vault" {
  address          = "http://vault.platform.svc.cluster.local:8200"
  skip_child_token = true
  skip_tls_verify  = true
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}

provider "vault" {
  address           = "http://vault.0xk3m.dev"
  skip_child_token  = true
}

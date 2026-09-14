locals {
  api_key_hostnames = ["obscura.0xk3m.dev"]
  obscura_api_key   = data.vault_kv_secret_v2.cloudflare.data["obscura"]
}

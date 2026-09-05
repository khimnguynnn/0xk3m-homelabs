locals {
  cloudflare_account_id = data.vault_kv_secret_v2.cloudflare.data["cloudflare_account_id"]
  cloudflare_api_token  = data.vault_kv_secret_v2.cloudflare.data["cloudflare_api_token"]
}

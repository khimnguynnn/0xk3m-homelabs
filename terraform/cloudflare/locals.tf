locals {
  cloudflare_account_id = data.vault_kv_secret_v2.cloudflare.data["cloudflare_account_id"]
  cloudflare_api_token  = data.vault_kv_secret_v2.cloudflare.data["cloudflare_api_token"]

  # mTLS protected hostnames (Cloudflare Managed CA)
  # Excluded: status.0xk3m.dev, charts.0xk3m.dev, vault.0xk3m.dev
  mtls_hostnames = ["grafana.0xk3m.dev"]
}

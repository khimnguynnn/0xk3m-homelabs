data "cloudflare_zero_trust_tunnel_cloudflared_token" "homelab" {
  account_id = local.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}

data "cloudflare_account_api_token_permission_groups_list" "tunnel_write" {
  account_id = local.cloudflare_account_id
  name       = "Cloudflare Tunnel Write"
  scope      = "com.cloudflare.api.account"
}

data "cloudflare_account_api_token_permission_groups_list" "dns_write" {
  account_id = local.cloudflare_account_id
  name       = "DNS Write"
  scope      = "com.cloudflare.api.account.zone"
}

data "cloudflare_account_api_token_permission_groups_list" "zone_read" {
  account_id = local.cloudflare_account_id
  name       = "Zone Read"
  scope      = "com.cloudflare.api.account.zone"
}

data "vault_kv_secret_v2" "cloudflare" {
  mount = "secret"
  name  = "terraform/cloudflare"
}

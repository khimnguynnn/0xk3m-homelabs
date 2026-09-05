data "cloudflare_zero_trust_tunnel_cloudflared_token" "homelab" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}

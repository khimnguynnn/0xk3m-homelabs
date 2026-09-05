resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id = var.cloudflare_account_id
  name       = "0xk3m-homelabs"
  config_src = "cloudflare"
}

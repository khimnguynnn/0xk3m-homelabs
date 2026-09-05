resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id = local.cloudflare_account_id
  name       = "0xk3m-homelabs"
  config_src = "cloudflare"
}

resource "cloudflare_account_token" "tunnel_ingress" {
  account_id = local.cloudflare_account_id
  name       = "0xk3m-homelabs-tunnel-ingress"

  policies = [
    {
      effect = "allow"
      permission_groups = [
        { id = data.cloudflare_account_api_token_permission_groups_list.tunnel_write.result[0].id },
      ]
      resources = jsonencode({
        "com.cloudflare.api.account.${local.cloudflare_account_id}" = "*"
      })
    },
    {
      effect = "allow"
      permission_groups = [
        { id = data.cloudflare_account_api_token_permission_groups_list.dns_write.result[0].id },
        { id = data.cloudflare_account_api_token_permission_groups_list.zone_read.result[0].id },
      ]
      # Account-owned tokens must nest zone resources under the account.
      resources = jsonencode({
        "com.cloudflare.api.account.${local.cloudflare_account_id}" = {
          "com.cloudflare.api.account.zone.*" = "*"
        }
      })
    },
  ]
}

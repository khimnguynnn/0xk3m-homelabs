# API token for the cloudflare-tunnel-ingress-controller.
# Permissions it needs (per the strrl controller):
#   - Account : Cloudflare Tunnel : Write
#   - Zone    : DNS               : Write
#   - Zone    : Zone              : Read
#
# The provider URL-encodes the name itself, so pass plain text here.

data "cloudflare_account_api_token_permission_groups_list" "tunnel_write" {
  account_id = var.cloudflare_account_id
  name       = "Cloudflare Tunnel Write"
  scope      = "com.cloudflare.api.account"
}

data "cloudflare_account_api_token_permission_groups_list" "dns_write" {
  account_id = var.cloudflare_account_id
  name       = "DNS Write"
  scope      = "com.cloudflare.api.account.zone"
}

data "cloudflare_account_api_token_permission_groups_list" "zone_read" {
  account_id = var.cloudflare_account_id
  name       = "Zone Read"
  scope      = "com.cloudflare.api.account.zone"
}

resource "cloudflare_account_token" "tunnel_ingress" {
  account_id = var.cloudflare_account_id
  name       = "0xk3m-homelabs-tunnel-ingress"

  policies = [
    {
      effect = "allow"
      permission_groups = [
        { id = data.cloudflare_account_api_token_permission_groups_list.tunnel_write.result[0].id },
      ]
      resources = jsonencode({
        "com.cloudflare.api.account.${var.cloudflare_account_id}" = "*"
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
        "com.cloudflare.api.account.${var.cloudflare_account_id}" = {
          "com.cloudflare.api.account.zone.*" = "*"
        }
      })
    },
  ]
}

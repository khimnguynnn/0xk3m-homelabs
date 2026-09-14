locals {
  api_key_hostnames = ["obscura.0xk3m.dev"]
  obscura_api_key   = data.vault_kv_secret_v2.cloudflare.data["obscura"]
}

resource "cloudflare_ruleset" "api_key_enforcement" {
  zone_id     = data.cloudflare_zone.homelab.id
  name        = "API Key Enforcement"
  phase       = "http_request_firewall_custom"
  kind        = "zone"
  description = "Require valid API key for protected endpoints"
  rules = [
    {
      description = "Block requests without valid API key"
      expression  = "(http.host in {\"${join("\" \"", local.api_key_hostnames)}\"}) and not (http.request.headers[\"authorization\"][0] eq \"Bearer ${local.obscura_api_key}\")"
      action      = "block"
      enabled     = true
    }
  ]
}

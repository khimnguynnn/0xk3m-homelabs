data "cloudflare_zone" "homelab" {
  filter = {
    name = "0xk3m.dev"
  }
}

resource "cloudflare_certificate_authorities_hostname_associations" "mtls" {
  zone_id   = data.cloudflare_zone.homelab.id
  hostnames = local.mtls_hostnames
}

resource "cloudflare_ruleset" "access_enforcement" {
  zone_id     = data.cloudflare_zone.homelab.id
  name        = "Access Enforcement"
  phase       = "http_request_firewall_custom"
  kind        = "zone"
  description = "Access control rules (mTLS and API key)"
  rules = [
    {
      description = "Block requests without valid client certificate"
      expression  = "(http.host in {\"${join("\" \"", local.mtls_hostnames)}\"}) and not cf.tls_client_auth.cert_verified and not http.request.uri.path in {\"/favicon.ico\" \"/robots.txt\"} and not starts_with(http.request.uri.path, \"/static\") and not starts_with(http.request.uri.path, \"/assets\")"
      action      = "block"
      enabled     = true
    },
    {
      description = "Block requests without valid API key"
      expression  = "(http.host in {\"${join("\" \"", local.api_key_hostnames)}\"}) and not (http.request.headers[\"authorization\"][0] eq \"Bearer ${local.obscura_api_key}\")"
      action      = "block"
      enabled     = true
    }
  ]
}

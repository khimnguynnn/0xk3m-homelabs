# ---------------------------------------------------------------------------
# mTLS for *.0xk3m.dev
#
# Clients must present a certificate signed by the CA generated below.
# Cloudflare validates it at the edge and blocks any request without a
# verified client cert (except the excluded hostnames).
# ---------------------------------------------------------------------------

# ---- Client CA (generated in Terraform) ----
resource "tls_private_key" "mtls_ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "mtls_ca" {
  private_key_pem = tls_private_key.mtls_ca.private_key_pem

  is_ca_certificate     = true
  validity_period_hours = 87600 # 10 years

  subject {
    common_name  = "${var.mtls_domain} mTLS Client CA"
    organization = "0xk3m"
  }

  allowed_uses = [
    "cert_signing",
    "crl_signing",
  ]
}

# ---- A client certificate signed by the CA (install this on clients) ----
resource "tls_private_key" "mtls_client" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "mtls_client" {
  private_key_pem = tls_private_key.mtls_client.private_key_pem

  subject {
    common_name  = "0xk3m-client"
    organization = "0xk3m"
  }
}

resource "tls_locally_signed_cert" "mtls_client" {
  cert_request_pem   = tls_cert_request.mtls_client.cert_request_pem
  ca_private_key_pem = tls_private_key.mtls_ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.mtls_ca.cert_pem

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "client_auth",
  ]
}

# ---- Upload the public CA to Cloudflare (private key stays in Terraform) ----
resource "cloudflare_mtls_certificate" "client_ca" {
  account_id   = local.cloudflare_account_id
  ca           = true
  name         = "0xk3m-mtls-client-ca"
  certificates = tls_self_signed_cert.mtls_ca.cert_pem
}

# ---- Zone lookup ----
data "cloudflare_zones" "root" {
  name = var.mtls_domain
  account = {
    id = local.cloudflare_account_id
  }
}

locals {
  zone_id = data.cloudflare_zones.root.result[0].id

  mtls_excluded_set = join(" ", [for h in var.mtls_excluded_hostnames : "\"${h}\""])

  mtls_expression = format(
    "(ends_with(http.host, \".%s\")%s) and not cf.tls_client_auth.cert_verified",
    var.mtls_domain,
    length(var.mtls_excluded_hostnames) > 0 ? " and not http.host in {${local.mtls_excluded_set}}" : ""
  )
}

# ---- Request a client cert on each real service hostname ----
resource "cloudflare_certificate_authorities_hostname_associations" "mtls" {
  zone_id             = local.zone_id
  mtls_certificate_id = cloudflare_mtls_certificate.client_ca.id
  hostnames           = var.mtls_hostnames
}

# ---- Forward the verified client cert to the origin as a header ----
resource "cloudflare_zero_trust_access_mtls_hostname_settings" "mtls" {
  zone_id = local.zone_id

  settings = [for h in var.mtls_hostnames : {
    hostname                      = h
    china_network                 = false
    client_certificate_forwarding = true
  }]
}

# ---- Enforce: block *.0xk3m.dev without a verified client cert ----
resource "cloudflare_ruleset" "mtls_enforce" {
  zone_id = local.zone_id
  name    = "mTLS enforcement"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      description = "Require an mTLS client certificate on *.${var.mtls_domain}"
      expression  = local.mtls_expression
      enabled     = true
    }
  ]
}

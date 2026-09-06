data "cloudflare_zone" "homelab" {
  filter = {
    name = "0xk3m.dev"
  }
}

resource "tls_private_key" "mtls_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "mtls_ca" {
  private_key_pem       = tls_private_key.mtls_ca.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = 87600 # 10 years

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]

  subject {
    common_name  = "0xk3m.dev mTLS Client CA"
    organization = "0xk3m-homelab"
  }
}

resource "cloudflare_mtls_certificate" "client_ca" {
  account_id   = local.cloudflare_account_id
  name         = "0xk3m.dev client CA"
  ca           = true
  certificates = tls_self_signed_cert.mtls_ca.cert_pem
  private_key  = tls_private_key.mtls_ca.private_key_pem
}

resource "cloudflare_certificate_authorities_hostname_associations" "mtls" {
  zone_id             = data.cloudflare_zone.homelab.id
  hostnames           = local.mtls_hostnames
  mtls_certificate_id = cloudflare_mtls_certificate.client_ca.id
}

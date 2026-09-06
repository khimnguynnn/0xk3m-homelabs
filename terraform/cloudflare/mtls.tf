data "cloudflare_zone" "homelab" {
  filter = {
    name = "0xk3m.dev"
  }
}

resource "cloudflare_certificate_authorities_hostname_associations" "mtls" {
  zone_id   = data.cloudflare_zone.homelab.id
  hostnames = local.mtls_hostnames
}

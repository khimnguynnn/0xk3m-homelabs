resource "vault_jwt_auth_backend" "google" {
  description        = "Google Workspace SSO - 0xk3m.dev"
  path               = "oidc"
  type               = "oidc"
  default_role       = "default"
  oidc_discovery_url = var.oidc_discovery_url
  bound_issuer       = var.oidc_bound_issuer
  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  tune {
    listing_visibility = "unauth"
    token_type         = "default-service"
    default_lease_ttl  = "1h"
    max_lease_ttl      = "8h"
  }
}

resource "vault_jwt_auth_backend_role" "google" {
  backend        = vault_jwt_auth_backend.google.path
  role_name      = "default"
  role_type      = "oidc"
  user_claim     = "email"
  oidc_scopes    = ["openid", "profile", "email"]
  token_ttl      = 3600
  token_max_ttl  = 28800
  token_policies = ["default"]


  bound_audiences = [var.oidc_client_id]

  allowed_redirect_uris = [
    "https://vault.0xk3m.dev/ui/vault/auth/oidc/oidc/callback"
  ]
}

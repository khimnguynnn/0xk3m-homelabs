module "auth" {
  source             = "./modules/auth"
  oidc_client_id     = var.oidc_client_id
  oidc_client_secret = var.oidc_client_secret
  oidc_discovery_url = var.oidc_discovery_url
  oidc_bound_issuer  = var.oidc_bound_issuer
}

module "policy" {
  source   = "./modules/policy"
  policies = var.policies
}

module "secrets" {
  source          = "./modules/secrets"
  secrets_engines = var.secrets_engines
}

module "identity" {
  source        = "./modules/identity"
  users         = var.users
  oidc_accessor = module.auth.oidc_accessor
}

module "audit" {
  source        = "./modules/audit"
  audit_devices = var.audit_devices
}

module "k8s_auth" {
  source          = "./modules/k8s_auth"
  kubernetes_host = var.k8s_host
  roles           = var.k8s_roles
}

resource "vault_token" "terraform_reader" {
  display_name = "terraform-reader"
  policies     = ["terraform-reader"]
  renewable    = true
  ttl          = "87600h"
  no_parent    = true

  depends_on = [module.policy]
}

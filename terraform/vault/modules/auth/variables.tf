variable "oidc_client_id" {
  type = string
}

variable "oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "oidc_discovery_url" {
  type    = string
  default = "https://accounts.google.com"
}

variable "oidc_bound_issuer" {
  type    = string
  default = "https://accounts.google.com"
}

variable "redirect_uris" {
  type    = list(string)
  default = ["https://vault.0xk3m.dev/ui/vault/auth/oidc/oidc/callback"]
}

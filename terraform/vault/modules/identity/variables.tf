variable "users" {
  type = map(object({
    policies = list(string)
  }))
  description = "Map of user email to their Vault policies. Email is used as alias name (matches OIDC user_claim = email)."
}

variable "oidc_accessor" {
  type        = string
  description = "The accessor of the OIDC auth backend, used to link identity aliases."
}

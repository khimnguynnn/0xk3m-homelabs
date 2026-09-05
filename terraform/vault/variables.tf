variable "vault_address" {
  type    = string
  default = "http://vault.0xk3m.dev"
}

variable "vault_token" {
  type      = string
  sensitive = true
}

variable "oidc_client_id" {
  type        = string
  description = "The client ID for the OIDC application. This is used to authenticate the Vault OIDC backend with the OIDC provider."
}

variable "oidc_client_secret" {
  type        = string
  sensitive   = true
  description = "The client secret for the OIDC application. This is used to authenticate the Vault OIDC backend with the OIDC provider."
}

variable "oidc_discovery_url" {
  type        = string
  description = "The URL for the OIDC discovery endpoint. This is used to fetch the OIDC configuration."
}

variable "oidc_bound_issuer" {
  type        = string
  description = "The expected issuer of the OIDC tokens. This should match the 'iss' claim in the JWT."
}

variable "redirect_uris" {
  type        = list(string)
  description = "List of allowed redirect URIs for OIDC authentication"
}

variable "policies" {
  type = map(object({
    policy = string
  }))
  description = "A map of policy names to their corresponding policy definitions. Each policy is defined as a string."
}

variable "secrets_engines" {
  type = map(object({
    description = string
    folders     = optional(list(string), [])
  }))
  description = "Map of KV v2 secret engine paths to their descriptions."
}

variable "k8s_host" {
  type        = string
  default     = "https://kubernetes.default.svc"
  description = "Kubernetes API server address for the Vault Kubernetes auth backend."
}

variable "k8s_roles" {
  type = map(object({
    service_accounts = list(string)
    namespaces       = list(string)
    policies         = list(string)
    token_ttl        = optional(number, 3600)
  }))
  description = "Kubernetes auth backend roles."
  default     = {}
}

variable "audit_devices" {
  type = map(object({
    type    = string
    options = map(string)
  }))
  description = "Map of audit device paths to their type and options."
  default     = {}
}

variable "users" {
  type = map(object({
    policies = list(string)
  }))
  description = "Map of user email to their Vault policies."
  default     = {}
}


variable "path" {
  type        = string
  default     = "kubernetes"
  description = "Mount path for the Kubernetes auth backend."
}

variable "kubernetes_host" {
  type        = string
  default     = "https://kubernetes.default.svc"
  description = "Kubernetes API server address. Defaults to in-cluster DNS."
}

variable "roles" {
  type = map(object({
    service_accounts = list(string)
    namespaces       = list(string)
    policies         = list(string)
    token_ttl        = optional(number, 3600)
  }))
  description = "Map of role names to their Kubernetes auth role config."
  default     = {}
}

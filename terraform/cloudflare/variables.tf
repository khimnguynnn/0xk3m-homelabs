variable "mtls_domain" {
  type        = string
  default     = "0xk3m.dev"
  description = "Root domain that mTLS is enforced on (matches *.<domain>)."
}

variable "mtls_hostnames" {
  type = list(string)
  default = [
    "vault.0xk3m.dev",
    "charts.0xk3m.dev",
    "grafana.0xk3m.dev",
  ]
  description = "Hostnames where Cloudflare requests a client certificate. Add a host here before exposing it, or the enforcement rule blocks it."
}

variable "mtls_excluded_hostnames" {
  type = list(string)
  default = [
    "status.0xk3m.dev",
  ]
  description = "Hostnames exempt from mTLS enforcement (e.g. a public status page)."
}

variable "cluster_name" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "gateway" {
  type    = string
  default = "192.168.73.1"
}

variable "machines" {
  type = map(object({
    type = string
    ip   = string
    disk = string
  }))
}

variable "github_username" {
  type        = string
  description = "GitHub username for ArgoCD repo access"
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub PAT for ArgoCD repo access"
}

variable "github_oauth_client_id" {
  type        = string
  description = "GitHub OAuth App Client ID for ArgoCD SSO"
}

variable "github_oauth_client_secret" {
  type        = string
  sensitive   = true
  description = "GitHub OAuth App Client Secret for ArgoCD SSO"
}

variable "vault_address" {
  type        = string
  default     = "http://vault.0xk3m.dev"
  description = "Vault server address."
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "Vault root or admin token."
}


variable "argocd_admin_password" {
  type        = string
  sensitive   = true
  description = "ArgoCD admin password (bcrypt hash or plain text)"
}

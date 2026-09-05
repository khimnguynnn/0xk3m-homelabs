oidc_discovery_url = "https://accounts.google.com"
oidc_bound_issuer  = "https://accounts.google.com"
redirect_uris      = ["https://vault.0xk3m.dev/ui/vault/auth/oidc/oidc/callback"]

k8s_roles = {
  "eso" = {
    service_accounts = ["external-secrets"]
    namespaces       = ["*"]
    policies         = ["app-reader"]
    token_ttl        = 3600
  }
}

audit_devices = {
  "file/" = {
    type = "file"
    options = {
      file_path = "/vault/logs/audit.log"
    }
  }
}

secrets_engines = {
  "secret" = {
    description = "General KV v2 secrets"
    folders     = ["app", "database", "gateway", "monitoring", "platform", "terraform"]
  }
}

users = {
  "khimnguynn@gmail.com" = {
    policies = ["sre-admin"]
  }
}

policies = {
  "default" = {
    policy = <<-EOT
    EOT
  }
  "terraform-reader" = {
    policy = <<-EOT
      path "secret/data/terraform/*" {
        capabilities = ["read"]
      }
      path "secret/metadata/terraform/*" {
        capabilities = ["read", "list"]
      }
    EOT
  }
  "sre-admin" = {
    policy = <<-EOT
      path "*" {
        capabilities = ["create", "read", "update", "delete", "list"]
      }
    EOT
  }
  "app-reader" = {
    policy = <<-EOT
      path "auth/token/lookup-self" {
        capabilities = ["read"]
      }
      path "auth/token/renew-self" {
        capabilities = ["update"]
      }
      path "secret/data/+/*" {
        capabilities = ["read"]
      }
      path "secret/metadata/+/*" {
        capabilities = ["read", "list"]
      }
    EOT
  }
}

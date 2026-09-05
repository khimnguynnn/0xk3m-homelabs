terraform {
  required_version = "1.5.7"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
  cloud {

    organization = "khiemnd"

    workspaces {
      name = "0xk3m-homelab-cloudflare"
    }
  }
}

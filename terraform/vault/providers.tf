provider "vault" {
  address         = var.vault_address
  token           = var.vault_token
  skip_tls_verify = true
}

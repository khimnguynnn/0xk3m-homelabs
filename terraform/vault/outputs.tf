output "terraform_reader_token" {
  value     = vault_token.terraform_reader.client_token
  sensitive = true
}

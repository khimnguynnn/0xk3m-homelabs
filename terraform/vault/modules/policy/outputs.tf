output "policy_names" {
  value = keys(vault_policy.this)
}

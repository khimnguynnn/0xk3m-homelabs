output "entity_ids" {
  value = { for k, v in vault_identity_entity.this : k => v.id }
}

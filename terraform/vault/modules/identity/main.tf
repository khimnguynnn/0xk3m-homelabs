resource "vault_identity_entity" "this" {
  for_each = var.users
  name     = each.key
  policies = each.value.policies
}

resource "vault_identity_entity_alias" "this" {
  for_each       = var.users
  name           = each.key
  mount_accessor = var.oidc_accessor
  canonical_id   = vault_identity_entity.this[each.key].id
}

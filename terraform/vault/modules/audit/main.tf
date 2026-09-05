resource "vault_audit" "this" {
  for_each = var.audit_devices
  type     = each.value.type
  path     = each.key
  options  = each.value.options
}

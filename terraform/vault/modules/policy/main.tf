resource "vault_policy" "this" {
  for_each = var.policies
  name = each.key

  policy = each.value.policy
}

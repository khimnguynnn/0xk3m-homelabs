resource "vault_mount" "this" {
  for_each    = var.secrets_engines
  path        = each.key
  type        = "kv"
  options     = { version = "2" }
  description = each.value.description
}

locals {
  folders = merge([
    for engine_key, engine in var.secrets_engines : {
      for folder in engine.folders :
      "${engine_key}/${folder}" => {
        engine = engine_key
        folder = folder
      }
    }
  ]...)
}

resource "vault_kv_secret_v2" "folder" {
  for_each  = local.folders
  mount     = vault_mount.this[each.value.engine].path
  name      = "${each.value.folder}/.keep"
  data_json = jsonencode({ managed_by = "terraform" })
}

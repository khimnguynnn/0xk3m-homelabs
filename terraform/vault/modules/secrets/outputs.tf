output "mount_paths" {
  value = { for k, v in vault_mount.this : k => v.path }
}

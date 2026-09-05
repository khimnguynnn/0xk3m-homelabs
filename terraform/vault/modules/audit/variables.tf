variable "audit_devices" {
  type = map(object({
    type    = string
    options = map(string)
  }))
  description = "Map of audit device paths to their type and options."
}

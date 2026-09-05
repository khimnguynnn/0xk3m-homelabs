variable "secrets_engines" {
  type = map(object({
    description = string
    folders     = optional(list(string), [])
  }))
  description = "Map of KV v2 secret engine paths to their descriptions and optional subfolder structure."
}

variable "policies" {
  type = map(object({
    policy = string
  }))
  description = "A map of policy names to their corresponding policy definitions. Each policy is defined as a string."
}

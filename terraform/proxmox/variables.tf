variable "proxmox_insecure" {
  description = "Skip TLS verification for self-signed certificates"
  type        = bool
  default     = true
}

variable "nodes" {
  description = "Map of node names to their VM IDs"
  type = map(object({
    description = string
    tags        = list(string)
    node_name  = string
    machine    = string
    bios       = string
    started    = bool
    stop_on_destroy = bool
    cpu = object({
      cores = number
      type  = string
    })
    memory = object({
      dedicated = number
    })
    cdrom = object({
      file_id   = string
      interface = string
    })
    disk = object({
      datastore_id = string
      interface    = string
      size         = number
      iothread     = bool
      discard      = string
    })
    network_device = object({
      bridge   = string
      model    = string
      firewall = bool
    })
    operating_system = object({
      type = string
    })
    boot_order = list(string)
  }))
}

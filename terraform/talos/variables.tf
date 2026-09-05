variable "cluster_name" {
  type = string
}

variable "gateway" {
  type    = string
  default = "192.168.73.1"
}

variable "machines" {
  type = map(object({
    type = string
    ip   = string
    disk = string
  }))
}


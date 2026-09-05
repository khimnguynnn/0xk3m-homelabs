resource "proxmox_virtual_environment_vm" "node" {
  for_each = var.nodes

  name            = each.key
  description     = each.value.description
  tags            = each.value.tags
  node_name       = each.value.node_name
  machine         = each.value.machine
  bios            = each.value.bios
  started         = each.value.started
  stop_on_destroy = each.value.stop_on_destroy

  cpu {
    cores = each.value.cpu.cores
    type  = each.value.cpu.type
  }

  memory {
    dedicated = each.value.memory.dedicated
  }

  cdrom {
    file_id   = each.value.cdrom.file_id
    interface = each.value.cdrom.interface
  }

  disk {
    datastore_id = each.value.disk.datastore_id
    interface    = each.value.disk.interface
    size         = each.value.disk.size
    iothread     = each.value.disk.iothread
    discard      = each.value.disk.discard
  }

  network_device {
    bridge   = each.value.network_device.bridge
    model    = each.value.network_device.model
    firewall = each.value.network_device.firewall
  }

  operating_system {
    type = each.value.operating_system.type
  }

  boot_order = each.value.boot_order
}

output "vm_ids" {
  value = { for k, v in proxmox_virtual_environment_vm.node : k => v.vm_id }
}

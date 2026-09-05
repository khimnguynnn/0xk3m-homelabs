proxmox_insecure = true

nodes = {
  k8s-cp-01 = {
    description     = "Kubernetes Control Plane - Talos"
    tags            = ["k8s", "control-plane", "talos"]
    node_name       = "pve"
    machine         = "q35"
    bios            = "seabios"
    started         = true
    stop_on_destroy = true
    cpu = {
      cores = 2
      type  = "host"
    }
    memory = {
      dedicated = 4096
    }
    cdrom = {
      file_id   = "local:iso/metal-amd64.iso"
      interface = "ide2"
    }
    disk = {
      datastore_id = "local-lvm"
      interface    = "virtio0"
      size         = 40
      iothread     = true
      discard      = "on"
    }
    network_device = {
      bridge   = "vmbr0"
      model    = "virtio"
      firewall = false
    }
    operating_system = {
      type = "l26"
    }
    boot_order = ["virtio0", "ide2"]
  }
  k8s-worker-01 = {
    description     = "Kubernetes Worker Node - Talos"
    tags            = ["k8s", "worker", "talos"]
    node_name       = "pve"
    machine         = "q35"
    bios            = "seabios"
    started         = true
    stop_on_destroy = true
    cpu = {
      cores = 6
      type  = "host"
    }
    memory = {
      dedicated = 14336
    }
    cdrom = {
      file_id   = "local:iso/metal-amd64.iso"
      interface = "ide2"
    }
    disk = {
      datastore_id = "local-lvm"
      interface    = "virtio0"
      size         = 100
      iothread     = true
      discard      = "on"
    }
    network_device = {
      bridge   = "vmbr0"
      model    = "virtio"
      firewall = false
    }
    operating_system = {
      type = "l26"
    }
    boot_order = ["virtio0", "ide2"]
  }
  k8s-worker-02 = {
    description     = "Kubernetes Worker Node - Talos"
    tags            = ["k8s", "worker", "talos"]
    node_name       = "pve"
    machine         = "q35"
    bios            = "seabios"
    started         = true
    stop_on_destroy = true
    cpu = {
      cores = 6
      type  = "host"
    }
    memory = {
      dedicated = 14336
    }
    cdrom = {
      file_id   = "local:iso/metal-amd64.iso"
      interface = "ide2"
    }
    disk = {
      datastore_id = "local-lvm"
      interface    = "virtio0"
      size         = 100
      iothread     = true
      discard      = "on"
    }
    network_device = {
      bridge   = "vmbr0"
      model    = "virtio"
      firewall = false
    }
    operating_system = {
      type = "l26"
    }
    boot_order = ["virtio0", "ide2"]
  }
}

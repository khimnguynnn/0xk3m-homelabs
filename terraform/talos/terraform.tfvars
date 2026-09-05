cluster_name = "0xk3m-k8s"
gateway      = "192.168.73.1"

machines = {
  cp = {
    type = "controlplane"
    ip   = "192.168.73.89"
    disk = "/dev/vda"
  }
  worker-01 = {
    type = "worker"
    ip   = "192.168.73.91"
    disk = "/dev/vda"
  }
  worker-02 = {
    type = "worker"
    ip   = "192.168.73.90"
    disk = "/dev/vda"
  }
}

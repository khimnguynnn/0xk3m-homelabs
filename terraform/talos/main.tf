# Cluster secrets (identity)
resource "talos_machine_secrets" "this" {}

# Machine configuration for each node
data "talos_machine_configuration" "node" {
  for_each = var.machines

  cluster_name     = var.cluster_name
  cluster_endpoint = local.cluster_endpoint
  machine_type     = each.value.type
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

# Client configuration for talosctl
data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for m in var.machines : m.ip if m.type == "controlplane"]
  endpoints            = [for m in var.machines : m.ip if m.type == "controlplane"]
}

# Apply config to each node
resource "talos_machine_configuration_apply" "node" {
  for_each = var.machines

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.node[each.key].machine_configuration
  node                        = each.value.ip

  config_patches = concat(
    [
      yamlencode({
        machine = {
          install = {
            disk = each.value.disk
          }
          network = {
            interfaces = [{
              interface = "ens18"
              addresses = ["${each.value.ip}/24"]
              routes = [{
                network = "0.0.0.0/0"
                gateway = var.gateway
              }]
            }]
            nameservers = ["1.1.1.1", "8.8.8.8"]
          }
        }
      })
    ],
    # No default CNI (flannel) and no kube-proxy - Cilium provides both
    each.value.type == "controlplane" ? [
      yamlencode({
        cluster = {
          network = {
            cni = {
              name = "none"
            }
          }
          proxy = {
            disabled = true
          }
        }
      })
    ] : []
  )
}

# Bootstrap cluster (only on first controlplane)
resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.node]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, m in var.machines : m.ip if m.type == "controlplane"][0]
}

# Get kubeconfig
resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, m in var.machines : m.ip if m.type == "controlplane"][0]
}

# Outputs
output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

# 0xk3m Homelab

<p>
  <img alt="GitOps" src="https://img.shields.io/badge/GitOps-Argo%20CD-EF7B4D?logo=argo&logoColor=white">
  <img alt="Kubernetes" src="https://img.shields.io/badge/Kubernetes-Talos%20Linux-7A5FFF?logo=kubernetes&logoColor=white">
  <img alt="Terraform" src="https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white">
  <img alt="Vault" src="https://img.shields.io/badge/Secrets-Vault%20%2B%20ESO-FFEC6E?logo=vault&logoColor=black">
  <img alt="Cloudflare" src="https://img.shields.io/badge/Ingress-Cloudflare%20Tunnel-F38020?logo=cloudflare&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/License-MIT-green">
</p>

A fully GitOps-driven homelab running a bare-metal Kubernetes cluster on [Talos Linux](https://www.talos.dev/), provisioned end-to-end with Terraform and continuously delivered with Argo CD. Compute, secrets, networking, and observability are all declarative and version-controlled in this single repository.

> Domain: `0xk3m.dev` · Everything from the hypervisor up is codified — no manual `kubectl apply`, no secrets in Git, no exposed ports.

---

## Architecture

```mermaid
flowchart TB
    subgraph EDGE["🌐 Cloudflare Edge"]
        CF["Zero Trust Tunnel<br/>+ mTLS enforcement"]
    end

    subgraph TFC["☁️ HCP Terraform Cloud"]
        WS["proxmox · talos · cloudflare · vault"]
    end

    subgraph AWS["🪣 AWS"]
        S3["S3 bucket<br/>(Loki object storage)"]
    end

    subgraph HW["🖥️ Bare Metal — Proxmox VE"]
        VM1["k8s-cp-01<br/>(control-plane)"]
        VM2["k8s-worker-01"]
        VM3["k8s-worker-02"]
    end

    subgraph K8S["☸️ Talos Kubernetes Cluster"]
        ARGO["Argo CD · app-of-apps"]
        subgraph platform["platform"]
            VAULT["Vault"]
            ESO["External Secrets"]
            CM["ChartMuseum"]
            AGENT["TFC Agent"]
            HOME["Homepage"]
        end
        subgraph kubesystem["kube-system"]
            CILIUM["Cilium<br/>(CNI + kube-proxy)"]
            METRICS["metrics-server"]
        end
        subgraph gw["gateway"]
            TUNNEL["Cloudflare Tunnel<br/>Ingress Controller"]
        end
        subgraph mon["monitoring"]
            PROM["Prometheus"]
            GRAF["Grafana"]
            LOKI["Loki"]
            PT["Promtail"]
        end
    end

    CF --> TUNNEL
    TFC -->|self-hosted agent| AGENT
    WS -->|provisions VMs| HW
    WS -->|bootstraps + installs Argo CD| K8S
    WS -->|tunnel · mTLS · API tokens| CF
    WS -->|policies / auth / secrets| VAULT
    ARGO -->|reconciles| platform & kubesystem & gw & mon
    ESO -->|syncs secrets| VAULT
    AGENT -.reads secrets.-> VAULT
    PT -->|ships logs| LOKI
    LOKI -->|chunks| S3
```

### The stack, layer by layer

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Hypervisor** | Proxmox VE 9.x | Runs the cluster VMs on a single 12th-gen Intel node |
| **OS** | Talos Linux | Immutable, API-driven Kubernetes OS (no SSH, no shell) |
| **IaC** | Terraform + HCP Terraform Cloud | Declarative provisioning, executed by a self-hosted agent inside the cluster |
| **Secrets** | HashiCorp Vault + External Secrets Operator | Single source of truth for all secrets; synced into K8s and read by Terraform |
| **GitOps** | Argo CD (app-of-apps) | Every workload is reconciled from this repo |
| **Networking** | Cilium + Cloudflare Tunnel | eBPF CNI (replaces kube-proxy) + zero-trust ingress with no exposed ports |
| **Edge security** | Cloudflare mTLS | Client-certificate enforcement in front of protected hostnames |
| **Metrics** | Prometheus + Grafana | Cluster metrics and dashboards |
| **Logs** | Loki + Promtail (+ AWS S3) | Log aggregation with object storage as the chunk backend |
| **Registry** | ChartMuseum | Private Helm chart repo at `charts.0xk3m.dev` |
| **Dashboard** | Homepage | Single landing page for all cluster services |

---

## Repository layout

```
.
├── terraform/                  # Infrastructure as Code (HCP Terraform Cloud)
│   ├── proxmox/                #   → provisions Talos VMs (bpg/proxmox)
│   ├── talos/                  #   → bootstraps K8s cluster + installs Argo CD
│   ├── cloudflare/             #   → Zero Trust tunnel, mTLS enforcement, scoped API tokens
│   ├── vault/                  #   → Vault config (modular: auth, policy, secrets, k8s, audit, identity)
│   └── aws/                    #   → S3 bucket + IAM user for Loki object storage
│
├── kubernetes/                 # GitOps source of truth (reconciled by Argo CD)
│   ├── bootstrap/root.yaml     #   → root "app-of-apps" entrypoint
│   ├── projects/               #   → Argo CD AppProjects + ApplicationSets
│   └── apps/                   #   → workloads grouped by project
│       ├── platform/           #     vault, external-secrets, chartmuseum, terraform-agent, homepage
│       ├── kube-system/        #     cilium, metrics-server
│       ├── gateway/            #     cloudflare-tunnel-ingress-controller
│       └── monitoring/         #     prometheus, grafana, loki, promtail
│
└── charts/                     # Reusable in-house Helm charts (published to ChartMuseum)
    ├── app/                    #   → generic app chart (deploy/svc/ingress/httproute/hpa/externalsecret)
    ├── external-secret-helper/ #   → ExternalSecret templating
    └── external-secret-store/  #   → (Cluster)SecretStore templating
```

---

## How it works

### 1. Provisioning (Terraform → HCP Terraform Cloud)

Terraform stacks run remotely on HCP Terraform Cloud, executed by a **self-hosted `tfc-agent` running inside the cluster** so runs can reach the private homelab network:

- **`proxmox`** — creates the Talos VMs on Proxmox (`bpg/proxmox`).
- **`talos`** — generates Talos machine config, bootstraps the cluster, and installs Argo CD via Helm. Talos is configured with **no default CNI and no kube-proxy** — Cilium takes over both.
- **`cloudflare`** — manages the Zero Trust tunnel, **mTLS enforcement rules**, and least-privilege API tokens.
- **`vault`** — configures Vault declaratively through purpose-built modules (`auth` for Google OIDC, `policy`, `secrets` for KV v2, `identity`, `audit`, `k8s_auth`).
- **`aws`** — provisions the S3 bucket and scoped IAM user that back Loki's log storage.

All stack secrets are pulled from Vault at plan/apply time (`secret/terraform/*`) rather than living in `.tfvars`.

### 2. Secrets (Vault + External Secrets Operator)

Vault (KV v2 at `secret/`) is the single source of truth. Two consumers:

- **Terraform** reads `secret/terraform/{cloudflare,proxmox,talos,aws}` via the Vault provider using a scoped `terraform-reader` token.
- **External Secrets Operator** syncs Vault paths into native Kubernetes `Secret`s through a `ClusterSecretStore` (`vault-backend`) authenticated with the Kubernetes auth method (role `eso`).

No plaintext secrets are committed — workloads reference an `ExternalSecret`, and ESO materializes the real value at runtime.

### 3. Delivery (Argo CD app-of-apps)

A single root `Application` (`kubernetes/bootstrap/root.yaml`) points at `kubernetes/projects/`, which defines one `AppProject` + `ApplicationSet` per domain. Each `ApplicationSet` uses a **Git file generator** that discovers apps from `kubernetes/apps/<project>/*/config.json` — so adding a new app is just committing a folder with a `config.json`, `Chart.yaml`, and `values.yaml`. Argo CD self-heals and prunes automatically.

### 4. Observability (metrics + logs)

- **Metrics** — Prometheus scrapes the cluster; Grafana visualizes it.
- **Logs** — Promtail ships pod logs to Loki, which stores chunks in an **AWS S3** bucket (provisioned by the `aws` stack) so log history survives node churn.

---

## Screenshots

| HCP Terraform Cloud workspaces | Proxmox VE host |
|:---:|:---:|
| ![Workspaces](images/Screenshot%202026-09-05%20at%2023.06.10.png) | ![Proxmox](images/Screenshot%202026-09-05%20at%2023.06.53.png) |

| Argo CD applications | Grafana cluster dashboard |
|:---:|:---:|
| ![Argo CD](images/Screenshot%202026-09-05%20at%2023.07.51.png) | ![Grafana](images/Screenshot%202026-09-05%20at%2023.08.32.png) |

---

## Design principles

- **Everything as code** — from VM creation to Grafana, nothing is clicked into existence.
- **Secrets never touch Git** — Vault is authoritative; ESO and the Vault Terraform provider fetch on demand.
- **GitOps by default** — `git push` is the deployment mechanism; Argo CD reconciles the rest.
- **Zero-trust ingress** — no ports are exposed; all inbound traffic arrives through a Cloudflare Tunnel, with mTLS in front of sensitive hostnames.
- **Immutable nodes** — Talos has no shell or package manager; the cluster is reproducible from config alone.

---

## Tech stack

`Proxmox VE` · `Talos Linux` · `Kubernetes` · `Terraform` · `HCP Terraform Cloud` · `HashiCorp Vault` · `External Secrets Operator` · `Argo CD` · `Cilium` · `Cloudflare Tunnel` · `Cloudflare mTLS` · `Gateway API` · `Prometheus` · `Grafana` · `Loki` · `Promtail` · `AWS S3` · `ChartMuseum` · `Homepage` · `Helm`

---

## License

[MIT](LICENSE) — feel free to borrow patterns for your own homelab. ⭐ the repo if it helped.

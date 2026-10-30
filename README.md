# 🏛️ Enterprise Azure Hub-and-Spoke Landing Zone (Terraform)

[![Terraform 1.9+](https://img.shields.io/badge/Terraform-1.9+-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure Provider v4+](https://img.shields.io/badge/AzureRM-v4.0+-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![CI/CD Validation](https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/workflows/ci-cd.yml)
[![Status: Reference Architecture](https://img.shields.io/badge/Status-Reference_Architecture_(Statically_Validated)-10B981?style=for-the-badge)](https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> **Reference Architecture · Statically Validated**  
> Enterprise Microsoft Azure Hub-and-Spoke Landing Zone implemented using modular Terraform. Designed around Microsoft Cloud Adoption Framework (CAF) standards, featuring centralized Azure Firewall (Standard SKU) traffic inspection, automated bidirectional VNet peering, custom User-Defined Routes (UDRs), Azure Bastion jumpbox connectivity, and dual-spoke (App & Data) network isolation.

---

## 📐 Network Topology & Traffic Routing

```mermaid
flowchart TD
    subgraph Hub["🏢 Central Connectivity Hub (10.0.0.0/16)"]
        AFW["🔥 Azure Firewall (Standard SKU)\nCentral 0.0.0.0/0 & East-West Inspection"]
        BASTION["🛡️ Azure Bastion Subnet\n(Zero-Public IP Jumpbox Access)"]
        GW["🌐 VPN / ExpressRoute Gateway\n(Hybrid On-Premises Interconnect)"]
    end

    subgraph SpokeApp["🚀 Spoke 1: Application Workload (10.10.0.0/16)"]
        UDR_APP["🛣️ Spoke UDR Table\nDefault 0.0.0.0/0 -> Azure Firewall"]
        APPS["💻 Application Subnet (10.10.1.0/24)\nPrivate Ingress & Compute"]
        APP_DATA["🗄️ App Data Subnet (10.10.2.0/24)\nService-Specific Storage"]
    end

    subgraph SpokeData["🗃️ Spoke 2: Data & Persistence Tier (10.20.0.0/16)"]
        UDR_DATA["🛣️ Spoke UDR Table\nDefault 0.0.0.0/0 -> Azure Firewall"]
        DB["💾 Managed Database Subnet (10.20.1.0/24)\nPostgreSQL / Storage"]
        ANALYTICS["📊 Analytics Subnet (10.20.2.0/24)\nInternal ETL & Worker Pools"]
    end

    Internet((🌍 Public Internet)) <-->|Egress Filtering (FQDN & L4)| AFW
    Hub <==>|Bidirectional VNet Peering| SpokeApp
    Hub <==>|Bidirectional VNet Peering| SpokeData

    APPS --> UDR_APP --> AFW
    AFW -->|East-West Inspected Routing| UDR_DATA --> DB
```

---

## 🎯 The Problem This Architecture Solves

Uncontrolled cloud adoption often results in:
1. **Network Sprawl & Ad-Hoc Peering:** Workloads interconnected directly without perimeter inspection, breaking auditability.
2. **Uninspected Outbound Internet Traffic:** Workload resources having public IPs or unfiltered egress, creating exfiltration vulnerabilities.
3. **Uncontrolled East-West Traffic:** Uninspected traffic between app and database tiers.

**Solution:** This Landing Zone implements a standardized transit Hub network routing all spoke-to-spoke and spoke-to-internet traffic through Azure Firewall via automated User-Defined Routes (`0.0.0.0/0 -> module.hub.firewall_private_ip`).

---

## ⚙️ Repository Structure

```text
azure-enterprise-landing-zone-terraform/
├── environments/
│   └── dev/
│       ├── main.tf              # Environment root: instantiates Hub, Spoke 1, and Spoke 2
│       ├── variables.tf         # Input declarations
│       ├── terraform.tfvars     # Parameter values (location, environment)
│       ├── outputs.tf           # Exposed IDs and Firewall private IP
│       └── provider.tf          # AzureRM provider & documented remote backend
└── modules/
    ├── hub_network/             # Hub VNet, Azure Firewall (Standard), Bastion, GatewaySubnet
    └── spoke_network/           # Spoke VNet, Subnets, UDR table, VNet Peering
```

---

## 📋 Authentication & Deployment

### 1. Passwordless CI/CD with GitHub OIDC
This project is designed for passwordless authentication via Microsoft Entra Workload Identity Federation (GitHub OIDC):
* Requires **no long-lived client secrets**.
* GitHub Actions requests a short-lived OIDC token validated by Azure federated credentials.

### 2. Local Initialization & Validation

```bash
cd environments/dev
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
```

### 3. Cleanup & Resource Teardown

```bash
terraform destroy -auto-approve
```

---

## 🔄 CI/CD Workflow & Quality Gates

Every pull request and push to `main` automatically triggers `.github/workflows/ci-cd.yml` in GitHub Actions:
- **`terraform fmt -check`**: Strict syntax formatting check
- **`tflint`**: AzureRM ruleset verification for deprecated attributes and provider anti-patterns
- **`checkov`**: Policy-as-Code SAST scan against CIS Microsoft Azure Foundations Benchmark
- **`gitleaks`**: High-entropy analysis preventing secret or token leaks

---

## 🛡️ Security Implementation Details

* **Zero Public IPs on Spoke Workloads:** All spoke subnets remain private with no direct public IPs.
* **Dynamic Egress Routing:** Spoke route tables reference the Azure Firewall private IP dynamically via module output (`module.hub.firewall_private_ip`).
* **Bastion Jumpbox Connectivity:** Management access is mediated through Azure Bastion without exposing SSH/RDP ports directly to the internet.
* **Standard SKU Alignment:** Configured for Azure Firewall Standard SKU (`sku_tier = "Standard"`, `sku_name = "AZFW_VNet"`), supporting Layer 4 network filtering and FQDN application rules without requiring custom enterprise CA certificates.

---

## 👨‍💻 Author & Cloud Consultant

**Sanjeev Singh**  
*Freelance Azure Cloud Engineer | Terraform & Infrastructure Automation*  
* 🌐 **Portfolio**: [sanjeevsingh.oneps.in](https://sanjeevsingh.oneps.in)  
* 💼 **LinkedIn**: [linkedin.com/in/sanjiivsingh](https://linkedin.com/in/sanjiivsingh)  
* 🐙 **GitHub**: [github.com/sanjiivsingh](https://github.com/sanjiivsingh)

---

## 📄 License
Licensed under the [MIT License](LICENSE).

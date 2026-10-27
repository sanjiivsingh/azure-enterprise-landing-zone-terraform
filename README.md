# 🏛️ Enterprise Azure Hub-and-Spoke Landing Zone (Terraform)

[![Terraform 1.9+](https://img.shields.io/badge/Terraform-1.9+-844FBA?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure Provider v4+](https://img.shields.io/badge/AzureRM-v4.0+-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
[![CAF Architecture](https://img.shields.io/badge/Architecture-Cloud_Adoption_Framework-10B981?style=for-the-badge)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> **Production-grade Microsoft Azure Hub-and-Spoke Landing Zone** implemented using modular Terraform. Designed around Microsoft Cloud Adoption Framework (CAF) standards, featuring centralized Azure Firewall inspection, automated bidirectional VNet peering, custom User Defined Routes (UDRs), Azure Bastion, and micro-segmented workload tiers.

---

## 📐 Network Topology & Traffic Routing

```mermaid
flowchart TD
    subgraph Hub["🏢 Central Connectivity Hub (10.0.0.0/16)"]
        AFW["🔥 Azure Firewall (Standard)
Egress & Ingress Inspection"]
        BASTION["🛡️ Azure Bastion Subnet
(Secure Jumpbox Access)"]
        GW["🌐 VPN / ExpressRoute Gateway
(Hybrid On-Premises Interconnect)"]
    end

    subgraph Spoke1["🚀 Workload Spoke VNet (10.10.0.0/16)"]
        UDR["🛣️ User-Defined Route (UDR)
Default 0.0.0.0/0 -> Azure Firewall"]
        APPS["💻 Application Subnet (10.10.1.0/24)
Private Ingress & Compute"]
        DATA["🗄️ Private Data Subnet (10.10.2.0/24)
Storage & Database Endpoints"]
    end

    Internet((🌍 Public Internet)) <-->|TLS 1.3 Inspection| AFW
    Hub <==>|Bidirectional VNet Peering| Spoke1
    UDR --> AFW
    APPS --> UDR
    DATA --> UDR
```

---

## 🎯 Architecture Features
* **Centralized Egress Inspection**: Route tables enforce default route `0.0.0.0/0` to Azure Firewall private IP.
* **Automated Bidirectional VNet Peering**: Decoupled modules automatically link spoke VNets to the central transit hub.
* **Micro-Segmented Security**: Subnet-level Network Security Groups (NSGs) preventing unauthorized lateral movement.
* **Hybrid-Ready**: Dedicated GatewaySubnet pre-configured for ExpressRoute and Site-to-Site VPN failover.

---

## 👨‍💻 Author & Cloud Consultant

**Sanjeev Kumar Singh**  
*Senior Cloud & DevSecOps Platform Engineer*  
* 📧 **Email**: [sanjeevsinghred@gmail.com](mailto:sanjeevsinghred@gmail.com)
* 🌐 **Portfolio**: [sanjeevsingh.oneps.in](https://sanjeevsingh.oneps.in)
* 💼 **LinkedIn**: [linkedin.com/in/sanjiivsingh](https://linkedin.com/in/sanjiivsingh)
* 🐙 **GitHub**: [github.com/sanjiivsingh](https://github.com/sanjiivsingh)

---

## 📄 License
Licensed under the [MIT License](LICENSE).

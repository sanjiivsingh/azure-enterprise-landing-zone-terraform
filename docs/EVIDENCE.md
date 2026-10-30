# Verification & Evidence Summary

This document presents concrete, audit-verified evidence of syntax validation, policy scanning, and automated CI execution.

## 1. Verified CI Workflow Executions (GitHub Actions)

* **Pipeline Name:** DevSecOps Landing Zone CI/CD (`.github/workflows/ci-cd.yml`)
* **Latest Passing Run ID:** `40450305601`
* **Direct CI Run URL:** [https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/runs/40450305601](https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/runs/40450305601)
* **Preceding Validated Run:** [https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/runs/40450027709](https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/runs/40450027709)

---

## 2. Static Code Validation Evidence

Command executed:
```bash
cd environments/dev
terraform init -backend=false
terraform validate
```

**Output:**
```text
Initializing modules...
- hub in ../../modules/hub_network
- spoke_app in ../../modules/spoke_network
- spoke_data in ../../modules/spoke_network

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 4.0"...
- Installing hashicorp/azurerm v4.81.0...

Success! The configuration is valid.
```

---

## 3. Estimated Infrastructure Cost (Infracost Summary)

| Component | SKU / Tier | Count | Est. Monthly Cost (USD) |
| :--- | :--- | :---: | :---: |
| **Azure Firewall** | Standard SKU (AZFW_VNet) | 1 | ~$912.50 |
| **Azure Bastion** | Standard SKU | 1 | ~$138.70 |
| **Public IP Addresses** | Standard Static (FW + Bastion) | 2 | ~$7.30 |
| **Virtual Networks & Subnets** | Hub + 2 Spokes (App, Data) | 3 VNets | Free (Base) |
| **VNet Peering** | Bidirectional Cross-VNet | 4 Peerings | Usage dependent (~$0.01/GB) |
| **Route Tables & UDRs** | Custom Routes | 2 | Free |
| **Total Base Monthly Est.** | | | **~$1,058.50 / month** |

> *Note on Sandbox Deployments:* Due to base Azure Firewall and Bastion hourly charges (~$1.45/hr), reference architectures should run through `terraform plan` for static evaluation, or deployed to an approved sandbox and destroyed immediately (`terraform destroy -auto-approve`).

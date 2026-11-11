# Verification & Evidence Summary

This document presents concrete, audit-verified evidence of syntax validation, policy scanning, and automated CI execution.

## 1. Verified CI Workflow Executions (GitHub Actions)

* **Pipeline Name:** DevSecOps Landing Zone CI/CD (`.github/workflows/ci-cd.yml`)
* **Latest Passing Run ID:** `40450305601`
* **Direct CI Run URL:** [https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/runs/40450305601](https://github.com/sanjiivsingh/azure-enterprise-landing-zone-terraform/actions/runs/40450305601)

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
- spoke_network in ../../modules/spoke-network
- hub_network in ../../modules/hub-network
- resource_group in ../../modules/resource-group

Initializing provider plugins...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed hashicorp/azurerm v5.12.0

Success! The configuration is valid.
```

---

## 3. Plan Verification Evidence

Command executed:
```bash
cd environments/dev
terraform plan
```

**Output Summary:**
```text
Plan: 28 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + firewall_private_ip = (known after apply)
  + hub_vnet_id         = (known after apply)
  + hub_vnet_name       = "vnet-oneps-dev-hub"
  + spoke_app_vnet_id   = (known after apply)
  + spoke_data_vnet_id  = (known after apply)
  + spoke_vnet_ids      = {
      + spoke_app  = (known after apply)
      + spoke_data = (known after apply)
    }
```

---

## 4. Estimated Infrastructure Cost (Infracost Summary)

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

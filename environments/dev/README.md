# Development Environment: Hub-and-Spoke Landing Zone

This directory contains the root orchestration layer for deploying the development instance of the Enterprise Azure Landing Zone.

---

## Architecture Blueprint

```mermaid
flowchart TD
    subgraph Hub["🏢 Central Connectivity Hub (vnet-oneps-dev-hub)"]
        AFW["🔥 Azure Firewall (Standard SKU)<br/>afw-oneps-dev-hub"]
        BAS["🛡️ Azure Bastion<br/>bas-oneps-dev-hub"]
        GW["🌐 GatewaySubnet (10.0.3.0/27)"]
    end

    subgraph SpokeApp["🚀 Application Spoke (vnet-oneps-dev-spoke-app)"]
        SNET_APP["💻 snet-oneps-dev-workload-apps (10.10.1.0/24)"]
        SNET_APPDATA["🗄️ snet-oneps-dev-private-data (10.10.2.0/24)"]
        UDR_APP["🛣️ rt-vnet-oneps-dev-spoke-app (0.0.0.0/0 -> AFW)"]
    end

    subgraph SpokeData["🗃️ Data Spoke (vnet-oneps-dev-spoke-data)"]
        SNET_DB["💾 snet-oneps-dev-managed-db (10.20.1.0/24)"]
        SNET_ANALYTICS["📊 snet-oneps-dev-analytics (10.20.2.0/24)"]
        UDR_DATA["🛣️ rt-vnet-oneps-dev-spoke-data (0.0.0.0/0 -> AFW)"]
    end

    Hub <-->|Bidirectional Peering| SpokeApp
    Hub <-->|Bidirectional Peering| SpokeData
    SNET_APP --> UDR_APP --> AFW
    SNET_DB --> UDR_DATA --> AFW
```

---

## Deployment Instructions

### 1. Initialize Working Directory
```bash
terraform init -backend=false
```

### 2. Validate Code Syntax & Configuration
```bash
terraform validate
```

### 3. Generate Execution Plan
```bash
terraform plan
```

### 4. Apply Infrastructure
```bash
terraform apply
```

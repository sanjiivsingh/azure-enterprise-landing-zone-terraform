# Architecture Decision Records (ADR)

## ADR-001: Hub-and-Spoke Mesh vs. Azure Virtual WAN (vWAN)

### Context
Organizations scaling multi-subscription Azure environments need predictable egress inspection and intra-workload isolation. Two primary architectural patterns exist:
1. Traditional Hub-and-Spoke VNet Topology (Azure Firewall + VNet Peering + UDRs)
2. Azure Virtual WAN (vWAN) with Secured Virtual Hub

### Decision
We selected **Traditional Hub-and-Spoke VNet Topology** for this reference architecture because:
- **Granular Routing Control:** Allows custom User-Defined Routes (UDRs) per subnet with exact route table attachments.
- **Cost Predictability:** Avoids the fixed base hourly cost of Virtual WAN hubs for seed-to-scale organizations.
- **Provider Portability:** Operates natively with standard `azurerm_virtual_network`, `azurerm_subnet`, and `azurerm_virtual_network_peering` resources without vWAN routing intent orchestration complexity.

---

## ADR-002: Azure Firewall Standard SKU vs. Premium SKU

### Context
Azure Firewall provides Standard and Premium tiers:
* **Standard SKU:** Network filtering (Layer 3/4), FQDN application filtering, built-in threat intelligence feed.
* **Premium SKU:** TLS termination/inspection, URL filtering, signature-based IDPS (Intrusion Detection and Prevention System).

### Decision
We standard-aligned to **Standard SKU** (`sku_name = "AZFW_VNet"`, `sku_tier = "Standard"`).  
* **Rationale:** Enterprise TLS inspection requires provisioning an internal Certificate Authority (CA) and root certificates on all client machines. Standard SKU offers robust perimeter egress filtering without requiring CA infrastructure dependencies.

---

## ADR-003: Passwordless GitHub OIDC Authentication

### Context
Authenticating CI/CD pipelines historically required generating long-lived Service Principal secrets (`ARM_CLIENT_SECRET`) stored in GitHub Secrets.

### Decision
Adopt **Microsoft Entra Workload Identity Federation (GitHub OIDC)**:
- **Zero Secret Rotation:** Eliminates secret expiration and rotation operational overhead.
- **Least-Privilege Scoping:** Tokens are minted on-demand for specific GitHub repository/branch claims.

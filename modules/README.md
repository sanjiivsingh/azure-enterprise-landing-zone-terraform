# Reusable Azure Terraform Child Modules

This directory contains enterprise-grade, decoupled Terraform child modules designed to implement Microsoft Cloud Adoption Framework (CAF) Hub-and-Spoke Landing Zones, perimeter security, and isolated workload spokes.

---

## Module Catalog

| # | Child Module | Primary Azure Resource | Key Purpose |
| :-: | :--- | :--- | :--- |
| 1 | [`resource-group`](./resource-group/README.md) | `azurerm_resource_group` | Provisions the logical lifecycle boundary and regional placement with standard CAF tags. |
| 2 | [`hub-network`](./hub-network/README.md) | `azurerm_virtual_network`, `azurerm_firewall`, `azurerm_bastion_host` | Provisions central transit Hub VNet, perimeter firewall with L4/FQDN filtering, and Bastion jumpbox. |
| 3 | [`spoke-network`](./spoke-network/README.md) | `azurerm_virtual_network`, `azurerm_virtual_network_peering`, `azurerm_route_table` | Provisions isolated workload spoke VNets, subnets, bidirectional Hub peering, and UDR forced routing. |

---

## Architectural Principles

1. **Scalable & Reusable**: Child modules accept typed `*_config` objects and avoid hardcoding environment names, CIDRs, or specific subscription details.
2. **Dynamic Composition**: All subnets, routes, and rule collections are driven dynamically using `for_each`.
3. **Decoupled Contracts**: The environment layer orchestrates dependencies using `locals.tf`, allowing new spokes (e.g. AI, Analytics, DMZ) to be added purely via configuration.
4. **Security by Default**: Standard SKU Azure Firewall, zero-public-IP workload spokes, and forced UDR egress inspection.

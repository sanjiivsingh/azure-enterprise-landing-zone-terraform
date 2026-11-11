# Hub Network Child Module

Enterprise child module for provisioning the centralized Hub Virtual Network, subnets (`AzureFirewallSubnet`, `AzureBastionSubnet`, `GatewaySubnet`), perimeter security (Azure Firewall with East-West inspection), and secure management jumpbox (Azure Bastion).

## Features

- **Scalable VNet & Subnet Provisioning:** Dynamic subnet map provisioning via `for_each`.
- **Perimeter Firewall:** Optional Azure Firewall (Standard SKU) with custom L4/FQDN network rule collections.
- **Zero-Public IP Management:** Integrated Azure Bastion jumpbox provisioning with dedicated public IP and Standard SKU.
- **Enterprise Alignment:** Full compliance with Microsoft Cloud Adoption Framework (CAF) Hub-and-Spoke topology.

## Inputs

| Name | Type | Description |
| :--- | :--- | :--- |
| `hub_network_config` | `object` | Configuration object with VNet parameters, subnets, firewall settings, and bastion settings. |

## Outputs

| Name | Type | Description |
| :--- | :--- | :--- |
| `hub_network_output` | `object` | Complete composite output including VNet, subnets, firewall, and bastion objects. |
| `hub_vnet_id` | `string` | The Resource ID of the Hub VNet. |
| `hub_vnet_name` | `string` | The name of the Hub VNet. |
| `firewall_private_ip`| `string` | Private IP of the Azure Firewall for UDR next-hop routing. |

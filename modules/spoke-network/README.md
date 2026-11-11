# Spoke Network Child Module

Reusable, decoupled child module for provisioning workload spoke Virtual Networks, configurable tier subnets, bidirectional VNet peering to a central Hub network, and User-Defined Route (UDR) tables enforcing forced tunneling (0.0.0.0/0) to the central Azure Firewall.

## Features

- **Dynamic Subnet Provisioning:** Flexible subnet maps driven via `for_each`.
- **Bidirectional Peering:** Provisions both Spoke-to-Hub and Hub-to-Spoke peering connections.
- **Forced Egress Routing (UDR):** Automatically creates a Route Table pointing `0.0.0.0/0` to the Azure Firewall private IP and associates all subnets.
- **Scalable Architecture:** Easily spin up arbitrary numbers of spokes (e.g., App, Data, AI, Shared Services) by passing configurations via `for_each`.

## Inputs

| Name | Type | Description |
| :--- | :--- | :--- |
| `spoke_network_config` | `object` | Configuration object with VNet parameters, subnets, Hub peering targets, and firewall IP. |

## Outputs

| Name | Type | Description |
| :--- | :--- | :--- |
| `spoke_network_output` | `object` | Complete composite output including VNet, subnets, peerings, and route table. |
| `spoke_vnet_id` | `string` | The Resource ID of the Spoke VNet. |
| `spoke_vnet_name` | `string` | The name of the Spoke VNet. |
| `subnets` | `map` | Map of all created subnets within this Spoke. |

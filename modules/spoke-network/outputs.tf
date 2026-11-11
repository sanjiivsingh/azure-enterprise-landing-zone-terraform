output "spoke_network_output" {
  description = "Complete composite output for the spoke virtual network, subnets, peerings, and route table"
  value = {
    vnet                 = azurerm_virtual_network.this
    subnets              = azurerm_subnet.subnets
    hub_to_spoke_peering = azurerm_virtual_network_peering.hub_to_spoke
    spoke_to_hub_peering = azurerm_virtual_network_peering.spoke_to_hub
    route_table          = length(azurerm_route_table.spoke_udr) > 0 ? azurerm_route_table.spoke_udr[0] : null
  }
}

output "spoke_vnet_id" {
  description = "The Resource ID of the spoke virtual network"
  value       = azurerm_virtual_network.this.id
}

output "spoke_vnet_name" {
  description = "The name of the spoke virtual network"
  value       = azurerm_virtual_network.this.name
}

output "subnets" {
  description = "Map of created subnets within this spoke"
  value       = azurerm_subnet.subnets
}

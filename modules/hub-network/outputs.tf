output "hub_network_output" {
  description = "Complete output object for the hub virtual network and associated services"
  value = {
    vnet                = azurerm_virtual_network.this
    subnets             = azurerm_subnet.subnets
    firewall            = length(azurerm_firewall.this) > 0 ? azurerm_firewall.this[0] : null
    firewall_private_ip = length(azurerm_firewall.this) > 0 ? azurerm_firewall.this[0].ip_configuration[0].private_ip_address : null
    bastion             = length(azurerm_bastion_host.this) > 0 ? azurerm_bastion_host.this[0] : null
  }
}

output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network"
  value       = azurerm_virtual_network.this.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.this.name
}

output "firewall_private_ip" {
  description = "Private IP of the Azure Firewall for UDR next-hop routing"
  value       = length(azurerm_firewall.this) > 0 ? azurerm_firewall.this[0].ip_configuration[0].private_ip_address : null
}

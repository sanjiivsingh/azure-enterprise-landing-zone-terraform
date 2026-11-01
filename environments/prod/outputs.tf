output "hub_vnet_id" {
  description = "The Resource ID of the central transit Hub Virtual Network."
  value       = module.hub.hub_vnet_id
}

output "firewall_private_ip" {
  description = "Private IP of the central Azure Firewall used as the next hop for UDR route tables."
  value       = module.hub.firewall_private_ip
}

output "spoke_app_vnet_id" {
  description = "The Resource ID of the application workload spoke VNet."
  value       = module.spoke_app.spoke_vnet_id
}

output "spoke_data_vnet_id" {
  description = "The Resource ID of the data & persistence workload spoke VNet."
  value       = module.spoke_data.spoke_vnet_id
}

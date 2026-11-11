output "hub_vnet_id" {
  description = "The Resource ID of the central transit Hub Virtual Network."
  value       = module.hub_network["hub1"].hub_vnet_id
}

output "hub_vnet_name" {
  description = "The name of the central transit Hub Virtual Network."
  value       = module.hub_network["hub1"].hub_vnet_name
}

output "firewall_private_ip" {
  description = "Private IP of the central Azure Firewall used as the next hop for UDR route tables."
  value       = module.hub_network["hub1"].firewall_private_ip
}

output "spoke_vnet_ids" {
  description = "Map of Resource IDs of all provisioned Spoke Virtual Networks."
  value = {
    for k, v in module.spoke_network : k => v.spoke_vnet_id
  }
}

output "spoke_app_vnet_id" {
  description = "The Resource ID of the application workload spoke VNet."
  value       = module.spoke_network["spoke_app"].spoke_vnet_id
}

output "spoke_data_vnet_id" {
  description = "The Resource ID of the data & persistence workload spoke VNet."
  value       = module.spoke_network["spoke_data"].spoke_vnet_id
}

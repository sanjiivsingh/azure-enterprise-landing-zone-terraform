output "hub_vnet_id" {
  value = module.hub.hub_vnet_id
}

output "firewall_ip" {
  value = module.hub.firewall_private_ip
}

output "spoke_vnet_id" {
  value = module.spoke.spoke_vnet_id
}

resource "azurerm_virtual_network" "this" {
  name                = var.spoke_network_config.name
  location            = var.spoke_network_config.location
  resource_group_name = var.spoke_network_config.resource_group_name
  address_space       = var.spoke_network_config.address_space
  tags                = var.spoke_network_config.tags
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.spoke_network_config.subnets
  name                 = each.value.name
  resource_group_name  = var.spoke_network_config.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
}

# Hub to Spoke Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-${var.spoke_network_config.hub_vnet_name}-to-${azurerm_virtual_network.this.name}"
  resource_group_name       = var.spoke_network_config.hub_resource_group_name
  virtual_network_name      = var.spoke_network_config.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

# Spoke to Hub Peering
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${azurerm_virtual_network.this.name}-to-${var.spoke_network_config.hub_vnet_name}"
  resource_group_name       = var.spoke_network_config.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.spoke_network_config.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

# User Defined Route (UDR) - Forced Tunneling 0.0.0.0/0 to Central Firewall
locals {
  udr_enabled = try(var.spoke_network_config.enable_udr, true)
}

resource "azurerm_route_table" "spoke_udr" {
  count                         = local.udr_enabled ? 1 : 0
  name                          = "rt-${var.spoke_network_config.name}"
  location                      = var.spoke_network_config.location
  resource_group_name           = var.spoke_network_config.resource_group_name
  bgp_route_propagation_enabled = true

  route {
    name                   = "DefaultRouteToFirewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.spoke_network_config.firewall_private_ip
  }

  tags = var.spoke_network_config.tags
}

resource "azurerm_subnet_route_table_association" "associations" {
  for_each       = local.udr_enabled ? azurerm_subnet.subnets : {}
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.spoke_udr[0].id
}

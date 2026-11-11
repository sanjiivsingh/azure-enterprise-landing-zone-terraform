resource "azurerm_virtual_network" "this" {
  name                = var.hub_network_config.name
  location            = var.hub_network_config.location
  resource_group_name = var.hub_network_config.resource_group_name
  address_space       = var.hub_network_config.address_space
  tags                = var.hub_network_config.tags
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.hub_network_config.subnets
  name                 = each.value.name
  resource_group_name  = var.hub_network_config.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
}

# --- Azure Firewall ---
locals {
  firewall_enabled = try(var.hub_network_config.firewall.enabled, false)
  bastion_enabled  = try(var.hub_network_config.bastion.enabled, false)

  fw_subnet_id = local.firewall_enabled ? (
    length([for s in azurerm_subnet.subnets : s.id if s.name == "AzureFirewallSubnet"]) > 0 ?
    [for s in azurerm_subnet.subnets : s.id if s.name == "AzureFirewallSubnet"][0] : null
  ) : null

  bastion_subnet_id = local.bastion_enabled ? (
    length([for s in azurerm_subnet.subnets : s.id if s.name == "AzureBastionSubnet"]) > 0 ?
    [for s in azurerm_subnet.subnets : s.id if s.name == "AzureBastionSubnet"][0] : null
  ) : null
}

resource "azurerm_public_ip" "firewall_pip" {
  count               = local.firewall_enabled ? 1 : 0
  name                = try(var.hub_network_config.firewall.pip_name, "pip-${var.hub_network_config.name}-afw")
  location            = var.hub_network_config.location
  resource_group_name = var.hub_network_config.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.hub_network_config.tags
}

resource "azurerm_firewall" "this" {
  count               = local.firewall_enabled ? 1 : 0
  name                = try(var.hub_network_config.firewall.name, "afw-${var.hub_network_config.name}")
  location            = var.hub_network_config.location
  resource_group_name = var.hub_network_config.resource_group_name
  sku_name            = try(var.hub_network_config.firewall.sku_name, "AZFW_VNet")
  sku_tier            = try(var.hub_network_config.firewall.sku_tier, "Standard")

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = local.fw_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall_pip[0].id
  }

  tags = var.hub_network_config.tags

  depends_on = [azurerm_subnet.subnets]
}

resource "azurerm_firewall_network_rule_collection" "rules" {
  count               = (local.firewall_enabled && length(try(var.hub_network_config.firewall.network_rules, [])) > 0) ? 1 : 0
  name                = "fw-netrules-collection"
  azure_firewall_name = azurerm_firewall.this[0].name
  resource_group_name = var.hub_network_config.resource_group_name
  priority            = 100
  action              = "Allow"

  dynamic "rule" {
    for_each = var.hub_network_config.firewall.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

# --- Azure Bastion ---
resource "azurerm_public_ip" "bastion_pip" {
  count               = local.bastion_enabled ? 1 : 0
  name                = try(var.hub_network_config.bastion.pip_name, "pip-${var.hub_network_config.name}-bas")
  location            = var.hub_network_config.location
  resource_group_name = var.hub_network_config.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.hub_network_config.tags
}

resource "azurerm_bastion_host" "this" {
  count               = local.bastion_enabled ? 1 : 0
  name                = try(var.hub_network_config.bastion.name, "bas-${var.hub_network_config.name}")
  location            = var.hub_network_config.location
  resource_group_name = var.hub_network_config.resource_group_name
  sku                 = try(var.hub_network_config.bastion.sku, "Standard")

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = local.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip[0].id
  }

  tags = var.hub_network_config.tags

  depends_on = [azurerm_subnet.subnets]
}

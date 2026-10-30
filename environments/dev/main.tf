locals {
  common_tags = {
    Environment = var.environment
    Architect   = "Sanjeev Singh"
    Contact     = "https://github.com/sanjiivsingh"
    Portfolio   = "https://sanjeevsingh.oneps.in"
    Framework   = "Azure Cloud Adoption Framework (CAF)"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "hub_rg" {
  name     = "rg-hub-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "spoke_app_rg" {
  name     = "rg-spoke-app-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "spoke_data_rg" {
  name     = "rg-spoke-data-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

module "hub" {
  source              = "../../modules/hub_network"
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = var.location
  hub_vnet_name       = "vnet-hub-${var.environment}"
  hub_address_space   = ["10.0.0.0/16"]
  tags                = local.common_tags
}

# Spoke 1: Application Compute Spoke (10.10.0.0/16)
module "spoke_app" {
  source                  = "../../modules/spoke_network"
  resource_group_name     = azurerm_resource_group.spoke_app_rg.name
  location                = var.location
  spoke_vnet_name         = "vnet-spoke-app-${var.environment}"
  spoke_address_space     = ["10.10.0.0/16"]
  hub_vnet_id             = module.hub.hub_vnet_id
  hub_vnet_name           = module.hub.hub_vnet_name
  hub_resource_group_name = azurerm_resource_group.hub_rg.name
  firewall_private_ip     = module.hub.firewall_private_ip
  tags                    = local.common_tags
}

# Spoke 2: Data & Database Spoke (10.20.0.0/16) - Proves East-West Spoke-to-Spoke Inspection
module "spoke_data" {
  source                  = "../../modules/spoke_network"
  resource_group_name     = azurerm_resource_group.spoke_data_rg.name
  location                = var.location
  spoke_vnet_name         = "vnet-spoke-data-${var.environment}"
  spoke_address_space     = ["10.20.0.0/16"]
  hub_vnet_id             = module.hub.hub_vnet_id
  hub_vnet_name           = module.hub.hub_vnet_name
  hub_resource_group_name = azurerm_resource_group.hub_rg.name
  firewall_private_ip     = module.hub.firewall_private_ip
  tags                    = local.common_tags
}

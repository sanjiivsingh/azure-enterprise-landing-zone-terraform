locals {
  common_tags = {
    Environment = var.environment
    Architect   = "Sanjeev Kumar Singh"
    Contact     = "sanjeevsinghred@gmail.com"
    Portfolio   = "sanjeevsingh.oneps.in"
    Framework   = "Azure Cloud Adoption Framework (CAF)"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "hub_rg" {
  name     = "rg-hub-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "spoke_rg" {
  name     = "rg-spoke-workload-${var.environment}"
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

module "spoke" {
  source              = "../../modules/spoke_network"
  resource_group_name = azurerm_resource_group.spoke_rg.name
  location            = var.location
  spoke_vnet_name     = "vnet-spoke-${var.environment}"
  spoke_address_space = ["10.10.0.0/16"]
  hub_vnet_id         = module.hub.hub_vnet_id
  hub_vnet_name       = module.hub.hub_vnet_name
  firewall_private_ip = module.hub.firewall_private_ip
  tags                = local.common_tags
}

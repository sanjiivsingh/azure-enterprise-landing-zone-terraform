locals {
  # Standardized prefix naming conventions
  rg_name_prefix      = "rg-${var.project}-${var.environment}"
  vnet_name_prefix    = "vnet-${var.project}-${var.environment}"
  subnet_name_prefix  = "snet-${var.project}-${var.environment}"
  fw_name_prefix      = "afw-${var.project}-${var.environment}"
  bastion_name_prefix = "bas-${var.project}-${var.environment}"
  rt_name_prefix      = "rt-${var.project}-${var.environment}"
  pip_name_prefix     = "pip-${var.project}-${var.environment}"

  common_tags = merge({
    Environment = var.environment
    Project     = var.project
    Architect   = "Sanjeev Singh"
    Contact     = "https://github.com/sanjiivsingh"
    Portfolio   = "https://sanjeevsingh.oneps.in"
    Framework   = "Azure Cloud Adoption Framework (CAF)"
    ManagedBy   = "Terraform"
  }, var.tags)

  # Derived Resource Group configurations
  resource_group = {
    for key, value in var.resource_group_config : key => {
      name     = "${local.rg_name_prefix}-${value.name_suffix}"
      location = var.location
      tags     = merge(local.common_tags, try(value.tags, {}))
    }
  }

  # Derived Hub Network configurations
  hub_network = {
    for key, value in var.hub_network_config : key => {
      name                = "${local.vnet_name_prefix}-${value.name_suffix}"
      resource_group_name = module.resource_group[value.rg_key].resource_group_output.name
      location            = var.location
      address_space       = value.address_space
      subnets = {
        for s_key, s_val in value.subnets : s_key => {
          name = s_val.name
          address_prefixes = [
            cidrsubnet(
              value.address_space[0],
              s_val.subnet_prefix - tonumber(split("/", value.address_space[0])[1]),
              s_val.subnet_num
            )
          ]
        }
      }
      firewall = {
        enabled  = try(value.firewall.enabled, true)
        name     = "${local.fw_name_prefix}-${value.name_suffix}"
        pip_name = "${local.pip_name_prefix}-fw-${value.name_suffix}"
        sku_name = try(value.firewall.sku_name, "AZFW_VNet")
        sku_tier = try(value.firewall.sku_tier, "Standard")
        network_rules = [
          {
            name                  = "SpokeToSpokeInternal"
            priority              = 100
            action                = "Allow"
            source_addresses      = ["10.110.0.0/16"]
            destination_addresses = ["10.120.0.0/16"]
            destination_ports     = ["443", "80", "5432"]
            protocols             = ["TCP"]
          },
          {
            name                  = "SpokeDataToAppInternal"
            priority              = 110
            action                = "Allow"
            source_addresses      = ["10.120.0.0/16"]
            destination_addresses = ["10.110.0.0/16"]
            destination_ports     = ["443", "80"]
            protocols             = ["TCP"]
          }
        ]
      }
      bastion = {
        enabled  = try(value.bastion.enabled, true)
        name     = "${local.bastion_name_prefix}-${value.name_suffix}"
        pip_name = "${local.pip_name_prefix}-bas-${value.name_suffix}"
        sku      = try(value.bastion.sku, "Standard")
      }
      tags = local.common_tags
    }
  }

  # Derived Spoke Network configurations
  spoke_network = {
    for key, value in var.spoke_network_config : key => {
      name                = "${local.vnet_name_prefix}-${value.name_suffix}"
      resource_group_name = module.resource_group[value.rg_key].resource_group_output.name
      location            = var.location
      address_space       = value.address_space
      subnets = {
        for s_key, s_val in value.subnets : s_key => {
          name = "${local.subnet_name_prefix}-${s_val.name_suffix}"
          address_prefixes = [
            cidrsubnet(
              value.address_space[0],
              s_val.subnet_prefix - tonumber(split("/", value.address_space[0])[1]),
              s_val.subnet_num
            )
          ]
        }
      }
      hub_vnet_id             = module.hub_network[value.hub_key].hub_vnet_id
      hub_vnet_name           = module.hub_network[value.hub_key].hub_vnet_name
      hub_resource_group_name = module.resource_group[var.hub_network_config[value.hub_key].rg_key].resource_group_output.name
      firewall_private_ip     = module.hub_network[value.hub_key].firewall_private_ip
      enable_udr              = try(value.enable_udr, true)
      tags                    = local.common_tags
    }
  }
}

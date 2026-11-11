module "resource_group" {
  source                = "../../modules/resource-group"
  for_each              = local.resource_group
  resource_group_config = each.value
}

module "hub_network" {
  source             = "../../modules/hub-network"
  for_each           = local.hub_network
  hub_network_config = each.value

  depends_on = [module.resource_group]
}

module "spoke_network" {
  source               = "../../modules/spoke-network"
  for_each             = local.spoke_network
  spoke_network_config = each.value

  depends_on = [module.hub_network]
}

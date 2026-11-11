resource "azurerm_resource_group" "this" {
  name     = var.resource_group_config.name
  location = var.resource_group_config.location
  tags     = var.resource_group_config.tags
}

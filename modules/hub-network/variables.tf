variable "hub_network_config" {
  description = "Configuration for the central hub virtual network, perimeter security, and jumpbox services"
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnets = optional(map(object({
      name             = string
      address_prefixes = list(string)
    })), {})
    firewall = optional(object({
      enabled  = optional(bool, true)
      name     = optional(string)
      pip_name = optional(string)
      sku_name = optional(string, "AZFW_VNet")
      sku_tier = optional(string, "Standard")
      network_rules = optional(list(object({
        name                  = string
        priority              = number
        action                = string
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
        protocols             = list(string)
      })), [])
    }))
    bastion = optional(object({
      enabled  = optional(bool, true)
      name     = optional(string)
      pip_name = optional(string)
      sku      = optional(string, "Standard")
    }))
    tags = optional(map(string), {})
  })
}

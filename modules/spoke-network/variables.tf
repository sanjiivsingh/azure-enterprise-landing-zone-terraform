variable "spoke_network_config" {
  description = "Configuration object for the spoke virtual network, subnets, peering, and route table"
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    subnets = optional(map(object({
      name             = string
      address_prefixes = list(string)
    })), {})
    hub_vnet_id             = string
    hub_vnet_name           = string
    hub_resource_group_name = string
    firewall_private_ip     = optional(string)
    enable_udr              = optional(bool, true)
    tags                    = optional(map(string), {})
  })
}

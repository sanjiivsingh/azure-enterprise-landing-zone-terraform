variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "spoke_vnet_name" {
  type = string
}

variable "spoke_address_space" {
  type = list(string)
}

variable "hub_vnet_id" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "firewall_private_ip" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

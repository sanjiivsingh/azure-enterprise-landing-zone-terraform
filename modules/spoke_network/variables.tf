variable "resource_group_name" {
  type        = string
  description = "Resource group name for the spoke workload."
}

variable "location" {
  type        = string
  description = "Azure region for deployment."
}

variable "spoke_vnet_name" {
  type        = string
  description = "Name of the spoke virtual network."
}

variable "spoke_address_space" {
  type        = list(string)
  description = "Address prefixes for the spoke VNet."
}

variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of the central transit Hub VNet."
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the central transit Hub VNet."
}

variable "hub_resource_group_name" {
  type        = string
  description = "Resource group name where the Hub VNet is provisioned."
}

variable "firewall_private_ip" {
  type        = string
  description = "Private IP of the centralized Azure Firewall for UDR routing."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}

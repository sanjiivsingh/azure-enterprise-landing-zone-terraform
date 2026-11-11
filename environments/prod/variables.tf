variable "project" {
  description = "Project or workload identifier"
  type        = string
  default     = "oneps"
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, prod)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Target Azure primary region"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Resource tags to be applied to all infrastructure"
  type        = map(string)
  default     = {}
}

variable "resource_group_config" {
  description = "Configuration map for resource groups"
  type = map(object({
    name_suffix = string
    tags        = optional(map(string))
  }))
}

variable "hub_network_config" {
  description = "Configuration map for hub virtual networks"
  type = map(object({
    name_suffix   = string
    rg_key        = string
    address_space = list(string)
    subnets = map(object({
      name          = string
      subnet_prefix = number
      subnet_num    = number
    }))
    firewall = optional(object({
      enabled  = optional(bool, true)
      sku_name = optional(string, "AZFW_VNet")
      sku_tier = optional(string, "Standard")
    }))
    bastion = optional(object({
      enabled = optional(bool, true)
      sku     = optional(string, "Standard")
    }))
  }))
}

variable "spoke_network_config" {
  description = "Configuration map for spoke virtual networks"
  type = map(object({
    name_suffix   = string
    rg_key        = string
    hub_key       = string
    address_space = list(string)
    subnets = map(object({
      name_suffix   = string
      subnet_prefix = number
      subnet_num    = number
    }))
    enable_udr = optional(bool, true)
  }))
}

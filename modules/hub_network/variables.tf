variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "hub_vnet_name" {
  type    = string
  default = "vnet-hub-core"
}

variable "hub_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

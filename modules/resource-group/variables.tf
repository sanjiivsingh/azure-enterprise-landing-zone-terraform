variable "resource_group_config" {
  description = "Configuration object for the resource group"
  type = object({
    name     = string
    location = string
    tags     = optional(map(string), {})
  })
}

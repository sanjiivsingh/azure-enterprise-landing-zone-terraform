# Resource Group Child Module

Reusable, decoupled child module for provisioning Azure Resource Groups with standard tagging and metadata.

## Resources Created

- `azurerm_resource_group.this`

## Inputs

| Name | Type | Description |
| :--- | :--- | :--- |
| `resource_group_config` | `object` | Map containing `name`, `location`, and optional `tags`. |

## Outputs

| Name | Type | Description |
| :--- | :--- | :--- |
| `resource_group_output` | `object` | The complete created `azurerm_resource_group` object. |

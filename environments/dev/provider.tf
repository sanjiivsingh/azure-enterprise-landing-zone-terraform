terraform {
  required_version = ">= 1.9.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Remote State Storage Backend (Azure Blob Storage with Lease State Locking)
  # Bootstrap via repository: sanjiivsingh/azure-terraform-bootstrap-oidc
  # To enable remote state, uncomment and provide backend configuration values:
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "<storage_account_name>"
  #   container_name       = "tfstate"
  #   key                  = "landing-zone/dev.terraform.tfstate"
  #   use_oidc             = true
  # }
}

provider "azurerm" {
  features {}
}

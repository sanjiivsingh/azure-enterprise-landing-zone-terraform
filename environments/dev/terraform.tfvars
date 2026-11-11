project     = "oneps"
environment = "dev"
location    = "eastus2"

tags = {
  ManagedBy  = "Terraform"
  Team       = "Platform-DevOps"
  Compliance = "CIS-Azure-v2.0"
}

# Resource Group Configurations
resource_group_config = {
  "hub_rg" = {
    name_suffix = "hub"
  }
  "spoke_app_rg" = {
    name_suffix = "spoke-app"
  }
  "spoke_data_rg" = {
    name_suffix = "spoke-data"
  }
}

# Hub Network Configuration
hub_network_config = {
  "hub1" = {
    name_suffix   = "hub"
    rg_key        = "hub_rg"
    address_space = ["10.0.0.0/16"]
    subnets = {
      "firewall" = {
        name          = "AzureFirewallSubnet"
        subnet_prefix = 26
        subnet_num    = 4 # 10.0.1.0/26
      }
      "bastion" = {
        name          = "AzureBastionSubnet"
        subnet_prefix = 26
        subnet_num    = 8 # 10.0.2.0/26
      }
      "gateway" = {
        name          = "GatewaySubnet"
        subnet_prefix = 27
        subnet_num    = 24 # 10.0.3.0/27
      }
    }
    firewall = {
      enabled  = true
      sku_name = "AZFW_VNet"
      sku_tier = "Standard"
    }
    bastion = {
      enabled = true
      sku     = "Standard"
    }
  }
}

# Spoke Network Configurations
spoke_network_config = {
  "spoke_app" = {
    name_suffix   = "spoke-app"
    rg_key        = "spoke_app_rg"
    hub_key       = "hub1"
    address_space = ["10.10.0.0/16"]
    enable_udr    = true
    subnets = {
      "workload" = {
        name_suffix   = "workload-apps"
        subnet_prefix = 24
        subnet_num    = 1 # 10.10.1.0/24
      }
      "private_data" = {
        name_suffix   = "private-data"
        subnet_prefix = 24
        subnet_num    = 2 # 10.10.2.0/24
      }
    }
  }

  "spoke_data" = {
    name_suffix   = "spoke-data"
    rg_key        = "spoke_data_rg"
    hub_key       = "hub1"
    address_space = ["10.20.0.0/16"]
    enable_udr    = true
    subnets = {
      "database" = {
        name_suffix   = "managed-db"
        subnet_prefix = 24
        subnet_num    = 1 # 10.20.1.0/24
      }
      "analytics" = {
        name_suffix   = "analytics"
        subnet_prefix = 24
        subnet_num    = 2 # 10.20.2.0/24
      }
    }
  }
}

terraform {
  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "platform-lz/terraform.tfstate"
    subscription_id      = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
    storage_account_name = "sttfstatepocproduks001"
    resource_group_name  = "rg-tfstate-prod-001"
    use_azuread_auth     = true
    snapshot             = true
  }
  required_providers {
    alz = {
      source  = "azure/alz"
      version = "~> 0.20.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.7.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4.0"
    }
  }
}

# Include the additional policies and override archetypes
provider "alz" {
  library_references = [
    {
      path = "platform/alz"
      ref  = "2025.09.3"
    },
    {
      "path" : "platform/amba",
      "ref" : "2025.11.0"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}

provider "azurerm" {
  features {}
  subscription_id = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
}

provider "azurerm" {
  alias = "management"
  features {}
  subscription_id = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
}

provider "azurerm" {
  alias = "connectivity"
  features {}
  subscription_id = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
}

provider "azapi" {
  alias           = "connectivity"
  subscription_id = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
}

provider "azurerm" {
  alias = "security"
  features {}
  subscription_id = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
}

provider "azapi" {
  alias           = "security"
  subscription_id = "8be4ef68-af99-4631-8f50-d8bdb4d822d8"
}


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.37.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "bitwarden-tf"
    storage_account_name = "bitwardentf"
    container_name       = "tfstate"
    key                  = "bitwarden.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

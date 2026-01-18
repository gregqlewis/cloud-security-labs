terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Uses Azure CLI authentication (az login)
  # Or service principal if ARM_* environment variables are set
}

provider "azuread" {
  # Uses same authentication as azurerm
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.13.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.6.5"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = "<account_id>"
}

provider "databricks" {
  alias = "workspace"
  host  = "<workspace_url>"
}


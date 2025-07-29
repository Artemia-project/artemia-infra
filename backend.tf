terraform {
  backend "azurerm" {
    resource_group_name  = "artemia-rg"
    storage_account_name = "artemiastatestore"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
# Main Data Storage Account
resource "azurerm_storage_account" "main_data" {
  name                            = var.main_storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  tags                            = var.tags
}

# Terraform State Storage Account
resource "azurerm_storage_account" "state" {
  name                            = var.state_storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  min_tls_version                 = var.min_tls_version
  tags                            = var.tags
}
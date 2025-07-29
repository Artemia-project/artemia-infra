# Main Data Storage Account
resource "azurerm_storage_account" "main_data" {
  account_replication_type        = var.account_replication_type
  account_tier                    = var.account_tier
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  location                        = var.location
  name                            = var.main_storage_account_name
  resource_group_name             = var.resource_group_name
  tags                            = var.tags
}

# Terraform State Storage Account
resource "azurerm_storage_account" "state" {
  account_replication_type        = var.account_replication_type
  account_tier                    = var.account_tier
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  location                        = var.location
  min_tls_version                 = var.min_tls_version
  name                            = var.state_storage_account_name
  resource_group_name             = var.resource_group_name
  tags                            = var.tags
}

# Storage Containers for State Storage
resource "azurerm_storage_container" "artemia" {
  name               = "artemia"
  storage_account_id = azurerm_storage_account.main_data.id
}

resource "azurerm_storage_container" "tfstate" {
  name               = "terraform-state"
  storage_account_id = azurerm_storage_account.state.id
}

# Queue Properties for State Storage
resource "azurerm_storage_account_queue_properties" "state" {
  storage_account_id = azurerm_storage_account.state.id

  hour_metrics {
    version = "1.0"
  }

  logging {
    delete  = false
    read    = false
    version = "1.0"
    write   = false
  }

  minute_metrics {
    version = "1.0"
  }
}
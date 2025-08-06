# Storage Containers for State Storage
resource "azurerm_storage_container" "artemia" {
  name               = "artemia"
  storage_account_id = azurerm_storage_account.main_data.id
}

resource "azurerm_storage_container" "tfstate" {
  name               = "terraform-state"
  storage_account_id = azurerm_storage_account.state.id
}
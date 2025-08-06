# SQL Database
resource "azurerm_mssql_database" "main" {
  name                 = var.database_name
  server_id            = azurerm_mssql_server.main.id
  storage_account_type = var.storage_account_type
  sku_name             = var.sku_name
  tags                 = var.tags
}
# Transparent Data Encryption
resource "azurerm_mssql_server_transparent_data_encryption" "main" {
  server_id = azurerm_mssql_server.main.id
}

# Server Security Alert Policy
resource "azurerm_mssql_server_security_alert_policy" "main" {
  server_name         = azurerm_mssql_server.main.name
  resource_group_name = var.resource_group_name
  state               = "Enabled"
}

# Virtual Network Rule
resource "azurerm_mssql_virtual_network_rule" "main" {
  name      = "${var.project_name}-VnetRule"
  server_id = azurerm_mssql_server.main.id
  subnet_id = var.subnet_id
}
# SQL Server
resource "azurerm_mssql_server" "main" {
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  location                     = var.location
  name                         = var.server_name
  resource_group_name          = var.resource_group_name
  version                      = var.server_version
  tags                         = var.tags

  azuread_administrator {
    azuread_authentication_only = var.azuread_authentication_only
    login_username              = var.azuread_admin_login_username
    object_id                   = var.azuread_admin_object_id
  }
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name                 = var.database_name
  server_id            = azurerm_mssql_server.main.id
  storage_account_type = var.storage_account_type
  tags                 = var.tags
}

# Transparent Data Encryption
resource "azurerm_mssql_server_transparent_data_encryption" "main" {
  server_id = azurerm_mssql_server.main.id
}

# Server Security Alert Policy
resource "azurerm_mssql_server_security_alert_policy" "main" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.main.name
  state               = "Enabled"
}

# Firewall Rules
resource "azurerm_mssql_firewall_rule" "allow_all_ips" {
  end_ip_address   = "255.255.255.255"
  name             = "AllowAllIps"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  end_ip_address   = "0.0.0.0"
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
}

# Virtual Network Rule
resource "azurerm_mssql_virtual_network_rule" "main" {
  name      = "${var.project_name}-VnetRule"
  server_id = azurerm_mssql_server.main.id
  subnet_id = var.subnet_id
}

# Extended Auditing Policies
resource "azurerm_mssql_database_extended_auditing_policy" "main" {
  database_id            = azurerm_mssql_database.main.id
  enabled                = false
  log_monitoring_enabled = false
}

resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.main.id
}

# Microsoft Support Auditing Policy
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "main" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.main.id
}
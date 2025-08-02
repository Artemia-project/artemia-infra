# SQL Server with Enhanced Security
resource "azurerm_mssql_server" "main" {
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  location                      = var.location
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  version                       = var.server_version
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.enable_public_access
  tags                          = var.tags

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
  sku_name             = var.sku_name
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

# Configurable Firewall Rules - Only created if public access is enabled
resource "azurerm_mssql_firewall_rule" "allowed_ips" {
  count            = var.enable_public_access ? length(var.allowed_ip_ranges) : 0
  end_ip_address   = var.allowed_ip_ranges[count.index].end_ip_address
  name             = var.allowed_ip_ranges[count.index].name
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = var.allowed_ip_ranges[count.index].start_ip_address
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

# Enhanced Auditing Policies
resource "azurerm_mssql_database_extended_auditing_policy" "main" {
  database_id                             = azurerm_mssql_database.main.id
  enabled                                 = var.enable_auditing
  log_monitoring_enabled                  = var.enable_auditing
  storage_endpoint                        = var.enable_auditing && var.audit_storage_account_id != null ? "${var.audit_storage_account_id}/" : null
  storage_account_access_key_is_secondary = false
  retention_in_days                       = var.enable_auditing ? 90 : null
}

resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  enabled                                 = var.enable_auditing
  log_monitoring_enabled                  = var.enable_auditing
  server_id                               = azurerm_mssql_server.main.id
  storage_endpoint                        = var.enable_auditing && var.audit_storage_account_id != null ? "${var.audit_storage_account_id}/" : null
  storage_account_access_key_is_secondary = false
  retention_in_days                       = var.enable_auditing ? 90 : null
}

# Microsoft Support Auditing Policy - Enhanced
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "main" {
  enabled                = var.enable_auditing
  log_monitoring_enabled = var.enable_auditing
  server_id              = azurerm_mssql_server.main.id
}
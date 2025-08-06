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
  server_id                               = azurerm_mssql_server.main.id
  enabled                                 = var.enable_auditing
  log_monitoring_enabled                  = var.enable_auditing
  storage_endpoint                        = var.enable_auditing && var.audit_storage_account_id != null ? "${var.audit_storage_account_id}/" : null
  storage_account_access_key_is_secondary = false
  retention_in_days                       = var.enable_auditing ? 90 : null
}

# Microsoft Support Auditing Policy - Enhanced
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "main" {
  server_id              = azurerm_mssql_server.main.id
  enabled                = var.enable_auditing
  log_monitoring_enabled = var.enable_auditing
}
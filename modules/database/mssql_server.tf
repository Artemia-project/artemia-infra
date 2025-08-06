# SQL Server with Enhanced Security
resource "azurerm_mssql_server" "main" {
  name                          = var.server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.enable_public_access
  tags                          = var.tags

  azuread_administrator {
    login_username              = var.azuread_admin_login_username
    object_id                   = var.azuread_admin_object_id
    azuread_authentication_only = var.azuread_authentication_only
  }
}
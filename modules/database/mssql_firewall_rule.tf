# Configurable Firewall Rules - Only created if public access is enabled
resource "azurerm_mssql_firewall_rule" "allowed_ips" {
  count            = var.enable_public_access ? length(var.allowed_ip_ranges) : 0
  name             = var.allowed_ip_ranges[count.index].name
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = var.allowed_ip_ranges[count.index].start_ip_address
  end_ip_address   = var.allowed_ip_ranges[count.index].end_ip_address
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
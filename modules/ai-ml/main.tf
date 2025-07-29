# Azure OpenAI Cognitive Services
resource "azurerm_cognitive_account" "openai" {
  custom_subdomain_name = var.custom_subdomain_name
  kind                  = var.kind
  location              = var.location
  name                  = var.cognitive_account_name
  resource_group_name   = var.resource_group_name
  sku_name              = var.sku_name
  tags                  = var.tags

  network_acls {
    default_action = var.network_acls_default_action
  }
}
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

# Azure AI Search Service
resource "azurerm_search_service" "search" {
  name                = var.search_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.search_service_sku
  tags                = var.tags

  replica_count   = var.search_replica_count
  partition_count = var.search_partition_count

  public_network_access_enabled = var.search_public_network_access
  local_authentication_enabled  = var.search_local_auth_enabled
}
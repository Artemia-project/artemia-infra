# EventHub Namespace
resource "azurerm_eventhub_namespace" "main" {
  local_authentication_enabled = var.local_authentication_enabled
  location                     = var.location
  name                         = var.namespace_name
  resource_group_name          = var.resource_group_name
  sku                          = var.namespace_sku
  tags                         = var.tags
}

# EventHub Namespace Authorization Rule
resource "azurerm_eventhub_namespace_authorization_rule" "main" {
  listen              = var.auth_rule_listen
  manage              = var.auth_rule_manage
  name                = var.auth_rule_name
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
  send                = var.auth_rule_send
}

# EventHub
resource "azurerm_eventhub" "main" {
  message_retention = var.message_retention
  name              = var.eventhub_name
  namespace_id      = azurerm_eventhub_namespace.main.id
  partition_count   = var.partition_count
}

# EventHub Consumer Groups
resource "azurerm_eventhub_consumer_group" "default" {
  eventhub_name       = azurerm_eventhub.main.name
  name                = "Default"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventhub_consumer_group" "llm_admin" {
  eventhub_name       = azurerm_eventhub.main.name
  name                = "llm.admin"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_eventhub_consumer_group" "llm_user" {
  eventhub_name       = azurerm_eventhub.main.name
  name                = "llm.user"
  namespace_name      = azurerm_eventhub_namespace.main.name
  resource_group_name = var.resource_group_name
}
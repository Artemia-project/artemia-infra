# Resource Group
resource "azurerm_resource_group" "main" {
  location = local.location
  name     = local.resource_group_name
  tags     = local.tags
}

# Network Module
module "network" {
  source = "../../modules/network"

  resource_group_name                 = azurerm_resource_group.main.name
  location                           = local.location
  project_name                       = "artemia"
  vnet_name                         = "artemia-vnet"
  vnet_address_space                = ["10.0.0.0/16"]
  default_subnet_address_prefixes   = ["10.0.0.0/24"]
  firewall_subnet_address_prefixes  = ["10.0.1.0/26"]
  load_balancer_name                = "artemia-load-balancer"
  tags                              = local.tags

  depends_on = [azurerm_resource_group.main]
}

# Compute Module
module "compute" {
  source = "../../modules/compute"

  resource_group_name             = azurerm_resource_group.main.name
  location                       = local.location
  project_name                   = "artemia"
  subnet_id                      = module.network.default_subnet_id
  backend_pool_id                = module.network.backend_pool_id
  backend_nsg_id                 = module.network.backend_nsg_id
  llm_nsg_id                     = module.network.llm_nsg_id
  elasticsearch_nsg_id           = module.network.elasticsearch_nsg_id
  
  admin_username                      = "azureuser"
  ssh_public_key_backend             = var.ssh_public_key_backend
  ssh_public_key_llm                 = var.ssh_public_key_llm
  ssh_public_key_elasticsearch       = var.ssh_public_key_elasticsearch
  
  backend_vm_size                    = "Standard_D2s_v5"
  llm_vm_size                       = "Standard_E4ds_v4"
  elasticsearch_vm_size             = "Standard_D2s_v5"
  
  backend_storage_account_type       = "StandardSSD_LRS"
  llm_storage_account_type          = "Premium_LRS"
  elasticsearch_storage_account_type = "Premium_LRS"
  
  tags = local.tags

  depends_on = [module.network]
}

# Database Module
module "database" {
  source = "../../modules/database"

  resource_group_name               = azurerm_resource_group.main.name
  location                         = local.location
  project_name                     = "artemia"
  server_name                      = "artemia-server"
  database_name                    = "artemia-database"
  administrator_login              = var.administrator_login
  administrator_login_password     = var.administrator_login_password
  server_version                   = "12.0"
  storage_account_type             = "Local"
  azuread_authentication_only      = false
  azuread_admin_login_username     = "artemia-group"
  azuread_admin_object_id          = "d671c231-b875-4048-92f7-39ea71f488c6"
  subnet_id                        = module.network.default_subnet_id
  sku_name                         = var.sku_name
  tags                             = local.tags

  depends_on = [azurerm_resource_group.main, module.network]
}

# Storage Module
module "storage" {
  source = "../../modules/storage"

  resource_group_name           = azurerm_resource_group.main.name
  location                     = local.location
  main_storage_account_name    = "artemiadata"
  state_storage_account_name   = "artemiastatestore"
  account_tier                 = "Standard"
  account_replication_type     = "LRS"
  allow_nested_items_to_be_public = false
  min_tls_version              = "TLS1_0"
  tags                         = local.tags

  depends_on = [azurerm_resource_group.main]
}

# Messaging Module
module "messaging" {
  source = "../../modules/messaging"

  resource_group_name              = azurerm_resource_group.main.name
  location                        = local.location
  namespace_name                  = "artemia-event-hubs-kafka"
  namespace_sku                   = "Standard"
  local_authentication_enabled   = false
  eventhub_name                   = "artemia-events"
  message_retention               = 1
  partition_count                 = 1
  auth_rule_name                  = "RootManageSharedAccessKey"
  auth_rule_listen                = true
  auth_rule_manage                = true
  auth_rule_send                  = true
  tags                           = local.tags

  depends_on = [azurerm_resource_group.main]
}

# AI/ML Module
module "ai_ml" {
  source = "../../modules/ai-ml"

  resource_group_name           = azurerm_resource_group.main.name
  location                     = local.location
  cognitive_account_name       = "artemia-openai"
  custom_subdomain_name        = "artemia-openai"
  kind                         = "OpenAI"
  sku_name                     = "S0"
  network_acls_default_action  = "Allow"
  tags                         = local.tags

  depends_on = [azurerm_resource_group.main]
}

# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  resource_group_name                = azurerm_resource_group.main.name
  primary_action_group_name          = "artemia-ag"
  recommended_action_group_name      = "RecommendedAlertRules-AG-1"
  primary_short_name                 = "Artemia AG"
  recommended_short_name             = "recalert1"
  primary_email                      = var.primary_email
  secondary_email                    = var.secondary_email
  
  vm_ids = {
    "artemia-backend-vm"      = module.compute.backend_vm_id
    "artemia-llm-vm"          = module.compute.llm_vm_id
    "artemia-elasticsearch-vm" = module.compute.elasticsearch_vm_id
  }
  
  cpu_threshold           = 80
  memory_threshold        = 1000000000
  disk_iops_threshold     = 95
  network_in_threshold    = 500000000000
  network_out_threshold   = 200000000000
  tags                    = local.tags

  depends_on = [azurerm_resource_group.main, module.compute]
}
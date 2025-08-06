# Resource Group
resource "azurerm_resource_group" "main" {
  location = local.location
  name     = local.resource_group_name
  tags     = local.tags
}

# Network Module with Enhanced Security
module "network" {
  source = "../../modules/network"

  resource_group_name              = azurerm_resource_group.main.name
  location                         = local.location
  project_name                     = var.project_name
  vnet_name                        = var.vnet_name
  vnet_address_space               = var.vnet_address_space
  default_subnet_address_prefixes  = var.default_subnet_address_prefixes
  firewall_subnet_address_prefixes = var.firewall_subnet_address_prefixes
  load_balancer_name               = var.load_balancer_name

  # Security Configuration
  allowed_ip_ranges            = var.allowed_ip_ranges
  ssh_allowed_ip_ranges        = var.ssh_allowed_ip_ranges
  enable_rdp_access            = var.enable_rdp_access
  airflow_ui_allowed_ip_ranges = var.airflow_ui_allowed_ip_ranges
  environment                  = "prod"

  tags = local.tags

  depends_on = [azurerm_resource_group.main]
}

# Compute Module
module "compute" {
  source = "../../modules/compute"

  resource_group_name  = azurerm_resource_group.main.name
  location             = local.location
  project_name         = var.project_name
  subnet_id            = module.network.default_subnet_id
  backend_pool_id      = module.network.backend_pool_id
  backend_nsg_id       = module.network.backend_nsg_id
  data_nsg_id          = module.network.data_nsg_id
  elasticsearch_nsg_id = module.network.elasticsearch_nsg_id

  admin_username               = var.admin_username
  ssh_public_key_backend       = var.ssh_public_key_backend
  ssh_public_key_data          = var.ssh_public_key_data
  ssh_public_key_elasticsearch = var.ssh_public_key_elasticsearch

  backend_vm_size       = var.backend_vm_size
  data_vm_size          = var.data_vm_size
  elasticsearch_vm_size = var.elasticsearch_vm_size

  backend_storage_account_type       = var.backend_storage_account_type
  data_storage_account_type          = var.data_storage_account_type
  elasticsearch_storage_account_type = var.elasticsearch_storage_account_type

  tags = local.tags

  depends_on = [module.network]
}

# Database Module with Enhanced Security
module "database" {
  source = "../../modules/database"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = local.location
  project_name                 = var.project_name
  server_name                  = var.server_name
  database_name                = var.database_name
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  server_version               = var.server_version
  storage_account_type         = var.storage_account_type
  azuread_authentication_only  = var.azuread_authentication_only
  azuread_admin_login_username = var.azuread_admin_login_username
  azuread_admin_object_id      = var.azuread_admin_object_id
  subnet_id                    = module.network.default_subnet_id
  sku_name                     = var.sku_name

  # Enhanced Security Configuration
  enable_public_access     = var.enable_database_public_access
  allowed_ip_ranges        = var.database_allowed_ips
  enable_auditing          = false
  audit_storage_account_id = null
  minimum_tls_version      = "1.2"

  tags = local.tags

  depends_on = [azurerm_resource_group.main, module.network]
}

# Storage Module
module "storage" {
  source = "../../modules/storage"

  resource_group_name             = azurerm_resource_group.main.name
  location                        = local.location
  main_storage_account_name       = var.main_storage_account_name
  state_storage_account_name      = var.state_storage_account_name
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  min_tls_version                 = var.min_tls_version
  tags                            = local.tags

  depends_on = [azurerm_resource_group.main]
}

# Messaging Module
module "messaging" {
  source = "../../modules/messaging"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = local.location
  namespace_name               = var.namespace_name
  namespace_sku                = var.namespace_sku
  local_authentication_enabled = var.local_authentication_enabled
  eventhub_name                = var.eventhub_name
  message_retention            = var.message_retention
  partition_count              = var.partition_count
  auth_rule_name               = var.auth_rule_name
  auth_rule_listen             = var.auth_rule_listen
  auth_rule_manage             = var.auth_rule_manage
  auth_rule_send               = var.auth_rule_send
  tags                         = local.tags

  depends_on = [azurerm_resource_group.main]
}

# AI/ML Module
module "ai_ml" {
  source = "../../modules/ai-ml"

  resource_group_name         = azurerm_resource_group.main.name
  location                    = local.location
  cognitive_account_name      = var.cognitive_account_name
  custom_subdomain_name       = var.custom_subdomain_name
  kind                        = var.cognitive_kind
  sku_name                    = var.cognitive_sku_name
  network_acls_default_action = var.network_acls_default_action
  search_service_name         = var.search_service_name
  tags                        = local.tags

  depends_on = [azurerm_resource_group.main]
}

# Monitoring Module
module "monitoring" {
  source = "../../modules/monitoring"

  resource_group_name           = azurerm_resource_group.main.name
  primary_action_group_name     = var.primary_action_group_name
  recommended_action_group_name = var.recommended_action_group_name
  primary_short_name            = var.primary_short_name
  recommended_short_name        = var.recommended_short_name
  primary_email                 = var.primary_email
  secondary_email               = var.secondary_email

  vm_ids = {
    "artemia-backend-vm"       = module.compute.backend_vm_id
    "artemia-data-vm"          = module.compute.data_vm_id
    "artemia-elasticsearch-vm" = module.compute.elasticsearch_vm_id
  }

  cpu_threshold         = var.cpu_threshold
  memory_threshold      = var.memory_threshold
  disk_iops_threshold   = var.disk_iops_threshold
  network_in_threshold  = var.network_in_threshold
  network_out_threshold = var.network_out_threshold
  tags                  = local.tags

  depends_on = [azurerm_resource_group.main, module.compute]
}

# Functions Module
module "functions" {
  source = "../../modules/functions"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = local.location
  function_app_name            = var.function_app_name
  app_service_plan_name        = var.app_service_plan_name
  storage_account_name         = var.function_storage_account_name
  runtime_name                 = var.function_runtime_name
  runtime_version              = var.function_runtime_version
  instance_memory_mb           = var.function_instance_memory_mb
  maximum_instance_count       = var.function_maximum_instance_count
  https_only                   = var.function_https_only
  public_network_access        = var.function_public_network_access
  key_vault_reference_identity = var.function_key_vault_reference_identity

  tags = local.tags

  depends_on = [azurerm_resource_group.main]
}

# Auto-shutdown Module for Cost Optimization
module "auto_shutdown" {
  source = "../../modules/auto-shutdown"

  enable_auto_shutdown       = var.enable_auto_shutdown
  auto_shutdown_time         = var.auto_shutdown_time
  auto_shutdown_timezone     = var.auto_shutdown_timezone
  auto_start_enabled         = var.auto_start_enabled
  auto_start_time            = var.auto_start_time
  weekend_shutdown_enabled   = var.weekend_shutdown_enabled
  enable_advanced_scheduling = var.enable_cost_optimization
  notification_email         = var.notification_email_shutdown != "" ? var.notification_email_shutdown : var.primary_email

  project_name        = var.project_name
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name

  backend_vm_id       = module.compute.backend_vm_id
  data_vm_id          = module.compute.data_vm_id
  elasticsearch_vm_id = module.compute.elasticsearch_vm_id

  tags = local.tags

  depends_on = [module.compute]
}
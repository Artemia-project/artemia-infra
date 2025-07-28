resource "azurerm_resource_group" "res-0" {
  location = "koreacentral"
  name     = "artemia-rg"
}
resource "azurerm_cognitive_account" "res-1" {
  custom_subdomain_name = "artemia-openai"
  kind                  = "OpenAI"
  location              = "koreacentral"
  name                  = "artemia-openai"
  resource_group_name   = "artemia-rg"
  sku_name              = "S0"
  network_acls {
    default_action = "Allow"
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_ssh_public_key" "res-5" {
  location            = "koreacentral"
  name                = "artemia-backend-vm-keypair"
  public_key          = var.ssh_public_key_backend
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_ssh_public_key" "res-6" {
  location            = "koreacentral"
  name                = "artemia-llm-vm-keypair"
  public_key          = var.ssh_public_key_llm
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_ssh_public_key" "res-7" {
  location            = "koreacentral"
  name                = "artemia-elasticsearch-vm-keypair"
  public_key          = var.ssh_public_key_elasticsearch
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_linux_virtual_machine" "res-8" {
  admin_username        = "azureuser"
  location              = "koreacentral"
  name                  = "artemia-backend-vm"
  network_interface_ids = [azurerm_network_interface.res-42.id]
  resource_group_name   = "artemia-rg"
  secure_boot_enabled   = true
  size                  = "Standard_D2s_v5"
  vtpm_enabled          = true
  additional_capabilities {
  }
  admin_ssh_key {
    public_key = var.ssh_public_key_backend
    username   = "azureuser"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "canonical"
    sku       = "server"
    version   = "latest"
  }
}
resource "azurerm_linux_virtual_machine" "res-9" {
  admin_username        = "azureuser"
  location              = "koreacentral"
  name                  = "artemia-llm-vm"
  network_interface_ids = [azurerm_network_interface.res-45.id]
  resource_group_name   = "artemia-rg"
  secure_boot_enabled   = true
  size                  = "Standard_E4ds_v4"
  vtpm_enabled          = true
  additional_capabilities {
  }
  admin_ssh_key {
    public_key = var.ssh_public_key_llm
    username   = "azureuser"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "canonical"
    sku       = "server"
    version   = "latest"
  }
}
resource "azurerm_linux_virtual_machine" "res-10" {
  admin_username        = "azureuser"
  location              = "koreacentral"
  name                  = "artemia-elasticsearch-vm"
  network_interface_ids = [azurerm_network_interface.res-48.id]
  resource_group_name   = "artemia-rg"
  secure_boot_enabled   = true
  size                  = "Standard_D2s_v5"
  vtpm_enabled          = true
  additional_capabilities {
  }
  admin_ssh_key {
    public_key = var.ssh_public_key_elasticsearch
    username   = "azureuser"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "ubuntu-24_04-lts"
    publisher = "canonical"
    sku       = "server"
    version   = "latest"
  }
}
resource "azurerm_eventhub_namespace" "res-11" {
  local_authentication_enabled = false
  location                     = "koreacentral"
  name                         = "artemia-event-hubs-kafka"
  resource_group_name          = "artemia-rg"
  sku                          = "Standard"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_eventhub_namespace_authorization_rule" "res-12" {
  listen              = true
  manage              = true
  name                = "RootManageSharedAccessKey"
  namespace_name      = "artemia-event-hubs-kafka"
  resource_group_name = "artemia-rg"
  send                = true
  depends_on = [
    azurerm_eventhub_namespace.res-11
  ]
}
resource "azurerm_eventhub" "res-13" {
  message_retention = 1
  name              = "artemia-events"
  namespace_id      = azurerm_eventhub_namespace.res-11.id
  partition_count   = 1
}
resource "azurerm_eventhub_consumer_group" "res-14" {
  eventhub_name       = "artemia-events"
  name                = "Default"
  namespace_name      = "artemia-event-hubs-kafka"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_eventhub.res-13
  ]
}
resource "azurerm_eventhub_consumer_group" "res-15" {
  eventhub_name       = "artemia-events"
  name                = "llm.admin"
  namespace_name      = "artemia-event-hubs-kafka"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_eventhub.res-13
  ]
}
resource "azurerm_eventhub_consumer_group" "res-16" {
  eventhub_name       = "artemia-events"
  name                = "llm.user"
  namespace_name      = "artemia-event-hubs-kafka"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_eventhub.res-13
  ]
}
resource "azurerm_monitor_action_group" "res-18" {
  name                = "artemia-ag"
  resource_group_name = "artemia-rg"
  short_name          = "Artemia AG"
  email_receiver {
    email_address = var.primary_email
    name          = "Artemia 알림_-EmailAction-"
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_monitor_metric_alert" "res-19" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Available Memory Bytes - artemia-backend-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-8.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actionGroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Available Memory Bytes"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = 1000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-20" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Available Memory Bytes - artemia-llm-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-9.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Available Memory Bytes"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = 1000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-21" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Available Memory Bytes - artemia-elasticsearch-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-10.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Available Memory Bytes"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = 1000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-22" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Data Disk IOPS Consumed Percentage - artemia-backend-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-8.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actionGroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Data Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 95
  }
}
resource "azurerm_monitor_metric_alert" "res-23" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Data Disk IOPS Consumed Percentage - artemia-llm-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-9.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Data Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 95
  }
}
resource "azurerm_monitor_metric_alert" "res-24" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Data Disk IOPS Consumed Percentage - artemia-elasticsearch-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-10.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Data Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 95
  }
}
resource "azurerm_monitor_metric_alert" "res-25" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network In Total - artemia-backend-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-8.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actionGroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "Network In Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 500000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-26" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network In Total - artemia-llm-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-9.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "Network In Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 500000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-27" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network In Total - artemia-elasticsearch-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-10.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "Network In Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 500000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-28" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network Out Total - artemia-backend-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-8.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actionGroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "Network Out Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 200000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-29" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network Out Total - artemia-llm-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-9.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "Network Out Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 200000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-30" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network Out Total - artemia-elasticsearch-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-10.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "Network Out Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 200000000000
  }
}
resource "azurerm_monitor_metric_alert" "res-31" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "OS Disk IOPS Consumed Percentage - artemia-backend-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-8.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actionGroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "OS Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 95
  }
}
resource "azurerm_monitor_metric_alert" "res-32" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "OS Disk IOPS Consumed Percentage - artemia-llm-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-9.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "OS Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 95
  }
}
resource "azurerm_monitor_metric_alert" "res-33" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "OS Disk IOPS Consumed Percentage - artemia-elasticsearch-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-10.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "OS Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 95
  }
}
resource "azurerm_monitor_metric_alert" "res-34" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Percentage CPU - artemia-backend-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-8.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actionGroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Percentage CPU"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 80
  }
}
resource "azurerm_monitor_metric_alert" "res-35" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Percentage CPU - artemia-llm-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-9.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Percentage CPU"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 80
  }
}
resource "azurerm_monitor_metric_alert" "res-36" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Percentage CPU - artemia-elasticsearch-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-10.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Percentage CPU"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = 80
  }
}
resource "azurerm_monitor_metric_alert" "res-37" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "VM Availability - artemia-backend-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-8.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actionGroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "VmAvailabilityMetric"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = 1
  }
}
resource "azurerm_monitor_metric_alert" "res-38" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "VM Availability - artemia-llm-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-9.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "VmAvailabilityMetric"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = 1
  }
}
resource "azurerm_monitor_metric_alert" "res-39" {
  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "VM Availability - artemia-elasticsearch-vm"
  resource_group_name = "artemia-rg"
  scopes              = [azurerm_linux_virtual_machine.res-10.id]
  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }
  action {
    action_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/microsoft.insights/actiongroups/RecommendedAlertRules-AG-1"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "VmAvailabilityMetric"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = 1
  }
}
resource "azurerm_lb" "res-40" {
  location            = "koreacentral"
  name                = "artemia-load-balancer"
  resource_group_name = "artemia-rg"
  frontend_ip_configuration {
    name  = "lb-frontend-ip"
    zones = ["1", "2", "3"]
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_lb_backend_address_pool" "res-41" {
  loadbalancer_id = azurerm_lb.res-40.id
  name            = "artemia-backend-pool"
}
resource "azurerm_network_interface" "res-42" {
  accelerated_networking_enabled = true
  location                       = "koreacentral"
  name                           = "artemia-backend-vm251"
  resource_group_name            = "artemia-rg"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.res-65.id
    subnet_id                     = azurerm_subnet.res-70.id
  }
}
resource "azurerm_network_interface_backend_address_pool_association" "res-43" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.res-41.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.res-42.id
}
resource "azurerm_network_interface_security_group_association" "res-44" {
  network_interface_id      = azurerm_network_interface.res-42.id
  network_security_group_id = azurerm_network_security_group.res-50.id
}
resource "azurerm_network_interface" "res-45" {
  accelerated_networking_enabled = true
  location                       = "koreacentral"
  name                           = "artemia-llm-vm538"
  resource_group_name            = "artemia-rg"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.res-66.id
    subnet_id                     = azurerm_subnet.res-70.id
  }
}
resource "azurerm_network_interface_backend_address_pool_association" "res-46" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.res-41.id
  ip_configuration_name   = "ipconfig1"
  network_interface_id    = azurerm_network_interface.res-45.id
}
resource "azurerm_network_interface_security_group_association" "res-47" {
  network_interface_id      = azurerm_network_interface.res-45.id
  network_security_group_id = azurerm_network_security_group.res-55.id
}
resource "azurerm_network_interface" "res-48" {
  accelerated_networking_enabled = true
  location                       = "koreacentral"
  name                           = "artemia-elasticsearch-vm291"
  resource_group_name            = "artemia-rg"
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.res-67.id
    subnet_id                     = azurerm_subnet.res-70.id
  }
}
resource "azurerm_network_interface_security_group_association" "res-49" {
  network_interface_id      = azurerm_network_interface.res-48.id
  network_security_group_id = azurerm_network_security_group.res-60.id
}
resource "azurerm_network_security_group" "res-50" {
  location            = "koreacentral"
  name                = "artemia-backend-vm-nsg"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_network_security_rule" "res-51" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP"
  network_security_group_name = "artemia-backend-vm-nsg"
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-50
  ]
}
resource "azurerm_network_security_rule" "res-52" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS"
  network_security_group_name = "artemia-backend-vm-nsg"
  priority                    = 320
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-50
  ]
}
resource "azurerm_network_security_rule" "res-53" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = "artemia-backend-vm-nsg"
  priority                    = 360
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-50
  ]
}
resource "azurerm_network_security_rule" "res-54" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "artemia-backend-vm-nsg"
  priority                    = 340
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-50
  ]
}
resource "azurerm_network_security_group" "res-55" {
  location            = "koreacentral"
  name                = "artemia-llm-vm-nsg"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_network_security_rule" "res-56" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP"
  network_security_group_name = "artemia-llm-vm-nsg"
  priority                    = 340
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-55
  ]
}
resource "azurerm_network_security_rule" "res-57" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS"
  network_security_group_name = "artemia-llm-vm-nsg"
  priority                    = 320
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-55
  ]
}
resource "azurerm_network_security_rule" "res-58" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = "artemia-llm-vm-nsg"
  priority                    = 360
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-55
  ]
}
resource "azurerm_network_security_rule" "res-59" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "artemia-llm-vm-nsg"
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-55
  ]
}
resource "azurerm_network_security_group" "res-60" {
  location            = "koreacentral"
  name                = "artemia-elasticsearch-vm-nsg"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_network_security_rule" "res-61" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "HTTP"
  network_security_group_name = "artemia-elasticsearch-vm-nsg"
  priority                    = 320
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-60
  ]
}
resource "azurerm_network_security_rule" "res-62" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "443"
  direction                   = "Inbound"
  name                        = "HTTPS"
  network_security_group_name = "artemia-elasticsearch-vm-nsg"
  priority                    = 340
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-60
  ]
}
resource "azurerm_network_security_rule" "res-63" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = "artemia-elasticsearch-vm-nsg"
  priority                    = 360
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-60
  ]
}
resource "azurerm_network_security_rule" "res-64" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = "artemia-elasticsearch-vm-nsg"
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = "artemia-rg"
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-60
  ]
}
resource "azurerm_public_ip" "res-65" {
  allocation_method   = "Static"
  location            = "koreacentral"
  name                = "artemia-backend-vm-ip"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_public_ip" "res-66" {
  allocation_method   = "Static"
  location            = "koreacentral"
  name                = "artemia-llm-vm-ip"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_public_ip" "res-67" {
  allocation_method   = "Static"
  location            = "koreacentral"
  name                = "artemia-elasticsearch-vm-ip"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_virtual_network" "res-68" {
  address_space       = ["10.0.0.0/16"]
  location            = "koreacentral"
  name                = "artemia-vnet"
  resource_group_name = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_subnet" "res-69" {
  address_prefixes     = ["10.0.1.0/26"]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "artemia-rg"
  virtual_network_name = "artemia-vnet"
  depends_on = [
    azurerm_virtual_network.res-68
  ]
}
resource "azurerm_subnet" "res-70" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "default"
  resource_group_name  = "artemia-rg"
  service_endpoints    = ["Microsoft.Sql"]
  virtual_network_name = "artemia-vnet"
  depends_on = [
    azurerm_virtual_network.res-68
  ]
}
resource "azurerm_mssql_server" "res-71" {
  administrator_login = "artemia_admin"
  location            = "koreacentral"
  name                = "artemia"
  resource_group_name = "artemia-rg"
  version             = "12.0"
  azuread_administrator {
    azuread_authentication_only = true
    login_username = "artemia-group"
    object_id      = "d671c231-b875-4048-92f7-39ea71f488c6"
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_mssql_database" "res-83" {
  name                 = "artemia"
  server_id            = azurerm_mssql_server.res-71.id
  storage_account_type = "Local"
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-89" {
  database_id            = azurerm_mssql_database.res-83.id
  enabled                = false
  log_monitoring_enabled = false
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-98" {
  database_id            = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/databases/master"
  enabled                = false
  log_monitoring_enabled = false
}
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "res-104" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.res-71.id
}
resource "azurerm_mssql_server_transparent_data_encryption" "res-105" {
  server_id = azurerm_mssql_server.res-71.id
}
resource "azurerm_mssql_server_extended_auditing_policy" "res-106" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.res-71.id
}
resource "azurerm_mssql_firewall_rule" "res-107" {
  end_ip_address   = "255.255.255.255"
  name             = "AllowAllIps"
  server_id        = azurerm_mssql_server.res-71.id
  start_ip_address = "0.0.0.0"
}
resource "azurerm_mssql_firewall_rule" "res-108" {
  end_ip_address   = "0.0.0.0"
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.res-71.id
  start_ip_address = "0.0.0.0"
}
resource "azurerm_mssql_server_security_alert_policy" "res-110" {
  resource_group_name = "artemia-rg"
  server_name         = "artemia"
  state               = "Enabled"
  depends_on = [
    azurerm_mssql_server.res-71
  ]
}
resource "azurerm_mssql_virtual_network_rule" "res-112" {
  name      = "artemia-VnetRule"
  server_id = azurerm_mssql_server.res-71.id
  subnet_id = azurerm_subnet.res-70.id
}
# resource "azurerm_mssql_server_vulnerability_assessment" "res-113" {
#   server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.res-110.id
#   storage_container_path          = "https://artemiastatestore.blob.core.windows.net/vulnerability-assessment"
# }
resource "azurerm_storage_account" "res-114" {
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  location                        = "koreacentral"
  min_tls_version                 = "TLS1_0"
  name                            = "artemiastatestore"
  resource_group_name             = "artemia-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_storage_container" "res-116" {
  name               = "artemia"
  storage_account_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore"
  depends_on = [
    # One of azurerm_storage_account.res-114,azurerm_storage_account_queue_properties.res-119 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_storage_container" "res-117" {
  name               = "tfstate"
  storage_account_id = "/subscriptions/${var.subscription_id}/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore"
  depends_on = [
    # One of azurerm_storage_account.res-114,azurerm_storage_account_queue_properties.res-119 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_storage_account_queue_properties" "res-119" {
  storage_account_id = azurerm_storage_account.res-114.id
  hour_metrics {
    version = "1.0"
  }
  logging {
    delete  = false
    read    = false
    version = "1.0"
    write   = false
  }
  minute_metrics {
    version = "1.0"
  }
}
resource "azurerm_monitor_action_group" "res-121" {
  name                = "RecommendedAlertRules-AG-1"
  resource_group_name = "artemia-rg"
  short_name          = "recalert1"
  email_receiver {
    email_address           = var.primary_email
    name                    = "Email0_-EmailAction-"
    use_common_alert_schema = true
  }
  email_receiver {
    email_address           = var.secondary_email
    name                    = "Email1_-EmailAction-"
    use_common_alert_schema = true
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}

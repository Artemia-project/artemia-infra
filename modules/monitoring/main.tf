# Action Groups
resource "azurerm_monitor_action_group" "main" {
  name                = var.primary_action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.primary_short_name
  tags                = var.tags

  email_receiver {
    email_address = var.primary_email
    name          = "Artemia 알림_-EmailAction-"
  }
}

resource "azurerm_monitor_action_group" "recommended" {
  name                = var.recommended_action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.recommended_short_name
  tags                = var.tags

  email_receiver {
    email_address           = var.primary_email
    name                    = "Email0_-EmailAction-"
    use_common_alert_schema = true
  }

  dynamic "email_receiver" {
    for_each = var.secondary_email != var.primary_email ? [1] : []
    content {
      email_address           = var.secondary_email
      name                    = "Email1_-EmailAction-"
      use_common_alert_schema = true
    }
  }
}

# VM Metric Alerts
resource "azurerm_monitor_metric_alert" "vm_cpu" {
  for_each = var.vm_ids

  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Percentage CPU - ${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value]

  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }

  action {
    action_group_id = azurerm_monitor_action_group.recommended.id
  }

  criteria {
    aggregation      = "Average"
    metric_name      = "Percentage CPU"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold
  }
}

resource "azurerm_monitor_metric_alert" "vm_memory" {
  for_each = var.vm_ids

  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Available Memory Bytes - ${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value]

  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }

  action {
    action_group_id = azurerm_monitor_action_group.recommended.id
  }

  criteria {
    aggregation      = "Average"
    metric_name      = "Available Memory Bytes"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = var.memory_threshold
  }
}

resource "azurerm_monitor_metric_alert" "vm_data_disk_iops" {
  for_each = var.vm_ids

  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Data Disk IOPS Consumed Percentage - ${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value]

  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }

  action {
    action_group_id = azurerm_monitor_action_group.recommended.id
  }

  criteria {
    aggregation      = "Average"
    metric_name      = "Data Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = var.disk_iops_threshold
  }
}

resource "azurerm_monitor_metric_alert" "vm_os_disk_iops" {
  for_each = var.vm_ids

  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "OS Disk IOPS Consumed Percentage - ${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value]

  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }

  action {
    action_group_id = azurerm_monitor_action_group.recommended.id
  }

  criteria {
    aggregation      = "Average"
    metric_name      = "OS Disk IOPS Consumed Percentage"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = var.disk_iops_threshold
  }
}

resource "azurerm_monitor_metric_alert" "vm_network_in" {
  for_each = var.vm_ids

  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network In Total - ${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value]

  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }

  action {
    action_group_id = azurerm_monitor_action_group.recommended.id
  }

  criteria {
    aggregation      = "Total"
    metric_name      = "Network In Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = var.network_in_threshold
  }
}

resource "azurerm_monitor_metric_alert" "vm_network_out" {
  for_each = var.vm_ids

  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "Network Out Total - ${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value]

  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }

  action {
    action_group_id = azurerm_monitor_action_group.recommended.id
  }

  criteria {
    aggregation      = "Total"
    metric_name      = "Network Out Total"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "GreaterThan"
    threshold        = var.network_out_threshold
  }
}

resource "azurerm_monitor_metric_alert" "vm_availability" {
  for_each = var.vm_ids

  auto_mitigate       = false
  frequency           = "PT5M"
  name                = "VM Availability - ${each.key}"
  resource_group_name = var.resource_group_name
  scopes              = [each.value]

  tags = {
    alertRuleCreatedWithAlertsRecommendations = "true"
  }

  action {
    action_group_id = azurerm_monitor_action_group.recommended.id
  }

  criteria {
    aggregation      = "Average"
    metric_name      = "VmAvailabilityMetric"
    metric_namespace = "Microsoft.Compute/virtualMachines"
    operator         = "LessThan"
    threshold        = 1
  }
}
# Auto-shutdown module for VM cost optimization
# This module creates auto-shutdown schedules for Azure VMs

# Auto-shutdown schedule for Backend VM
resource "azurerm_dev_test_global_vm_shutdown_schedule" "backend" {
  count              = var.enable_auto_shutdown ? 1 : 0
  virtual_machine_id = var.backend_vm_id
  location           = var.location
  enabled            = true

  daily_recurrence_time = var.auto_shutdown_time
  timezone              = var.auto_shutdown_timezone

  notification_settings {
    enabled         = var.notification_email != "" ? true : false
    time_in_minutes = 30
    email           = var.notification_email
  }

  tags = var.tags
}

# Auto-shutdown schedule for Data VM
resource "azurerm_dev_test_global_vm_shutdown_schedule" "data" {
  count              = var.enable_auto_shutdown ? 1 : 0
  virtual_machine_id = var.data_vm_id
  location           = var.location
  enabled            = true

  daily_recurrence_time = var.auto_shutdown_time
  timezone              = var.auto_shutdown_timezone

  notification_settings {
    enabled         = var.notification_email != "" ? true : false
    time_in_minutes = 30
    email           = var.notification_email
  }

  tags = var.tags
}

# Auto-shutdown schedule for Elasticsearch VM
resource "azurerm_dev_test_global_vm_shutdown_schedule" "elasticsearch" {
  count              = var.enable_auto_shutdown ? 1 : 0
  virtual_machine_id = var.elasticsearch_vm_id
  location           = var.location
  enabled            = true

  daily_recurrence_time = var.auto_shutdown_time
  timezone              = var.auto_shutdown_timezone

  notification_settings {
    enabled         = var.notification_email != "" ? true : false
    time_in_minutes = 30
    email           = var.notification_email
  }

  tags = var.tags
}

# Automation Account for VM start/stop (optional - for advanced scheduling)
resource "azurerm_automation_account" "vm_automation" {
  count                         = var.enable_advanced_scheduling ? 1 : 0
  name                          = "${var.project_name}-vm-automation"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku_name                      = "Basic"
  public_network_access_enabled = true

  tags = var.tags
}

# PowerShell Runbook for VM start operations
resource "azurerm_automation_runbook" "start_vms" {
  count                   = var.enable_advanced_scheduling ? 1 : 0
  name                    = "Start-VMs"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.vm_automation[0].name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"

  content = <<-CONTENT
# PowerShell script to start VMs
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$true)]
    [string[]]$VMNames
)

# Authenticate using Managed Identity
Connect-AzAccount -Identity

Write-Output "Starting VMs in resource group: $ResourceGroupName"

foreach ($vmName in $VMNames) {
    try {
        Write-Output "Starting VM: $vmName"
        Start-AzVM -ResourceGroupName $ResourceGroupName -Name $vmName -NoWait
        Write-Output "Start command sent for VM: $vmName"
    }
    catch {
        Write-Error "Failed to start VM $vmName`: $($_.Exception.Message)"
    }
}

Write-Output "VM start operations completed"
CONTENT

  tags = var.tags
}

# Schedule for weekend shutdown (Friday evening)
resource "azurerm_automation_schedule" "weekend_shutdown" {
  count                   = var.weekend_shutdown_enabled ? 1 : 0
  name                    = "Weekend-Shutdown"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.vm_automation[0].name
  frequency               = "Week"
  interval                = 1
  timezone                = var.auto_shutdown_timezone
  start_time              = "2024-01-05T18:00:00Z" # Friday
  week_days               = ["Friday"]

  description = "Weekend shutdown schedule - stops VMs on Friday evening"
}

# Schedule for Monday morning startup
resource "azurerm_automation_schedule" "monday_startup" {
  count                   = var.weekend_shutdown_enabled && var.auto_start_enabled ? 1 : 0
  name                    = "Monday-Startup"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.vm_automation[0].name
  frequency               = "Week"
  interval                = 1
  timezone                = var.auto_shutdown_timezone
  start_time              = "2024-01-08T09:00:00Z" # Monday
  week_days               = ["Monday"]

  description = "Monday startup schedule - starts VMs on Monday morning"
}
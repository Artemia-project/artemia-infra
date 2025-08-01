output "backend_shutdown_schedule_id" {
  description = "ID of the backend VM shutdown schedule"
  value       = var.enable_auto_shutdown ? azurerm_dev_test_global_vm_shutdown_schedule.backend[0].id : null
}

output "data_shutdown_schedule_id" {
  description = "ID of the Data VM shutdown schedule"
  value       = var.enable_auto_shutdown ? azurerm_dev_test_global_vm_shutdown_schedule.data[0].id : null
}

output "elasticsearch_shutdown_schedule_id" {
  description = "ID of the Elasticsearch VM shutdown schedule"
  value       = var.enable_auto_shutdown ? azurerm_dev_test_global_vm_shutdown_schedule.elasticsearch[0].id : null
}

output "automation_account_id" {
  description = "ID of the automation account (if enabled)"
  value       = var.enable_advanced_scheduling ? azurerm_automation_account.vm_automation[0].id : null
}

output "cost_savings_estimate" {
  description = "Estimated monthly cost savings information"
  value = var.enable_auto_shutdown ? {
    daily_shutdown_hours = "10-14 hours per day"
    weekend_shutdown_hours = var.weekend_shutdown_enabled ? "60+ hours per weekend" : "N/A"
    estimated_monthly_savings = "30-60% of VM compute costs"
    annual_savings_estimate = "~$3,000-8,000 for 3 VMs"
  } : null
}
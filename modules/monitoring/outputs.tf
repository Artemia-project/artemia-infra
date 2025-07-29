output "primary_action_group_id" {
  description = "ID of the primary action group"
  value       = azurerm_monitor_action_group.main.id
}

output "recommended_action_group_id" {
  description = "ID of the recommended action group"
  value       = azurerm_monitor_action_group.recommended.id
}

output "metric_alert_ids" {
  description = "IDs of all metric alerts"
  value = merge(
    { for k, v in azurerm_monitor_metric_alert.vm_cpu : "cpu-${k}" => v.id },
    { for k, v in azurerm_monitor_metric_alert.vm_memory : "memory-${k}" => v.id },
    { for k, v in azurerm_monitor_metric_alert.vm_data_disk_iops : "data-disk-iops-${k}" => v.id },
    { for k, v in azurerm_monitor_metric_alert.vm_os_disk_iops : "os-disk-iops-${k}" => v.id },
    { for k, v in azurerm_monitor_metric_alert.vm_network_in : "network-in-${k}" => v.id },
    { for k, v in azurerm_monitor_metric_alert.vm_network_out : "network-out-${k}" => v.id },
    { for k, v in azurerm_monitor_metric_alert.vm_availability : "vm-availability-${k}" => v.id }
  )
}
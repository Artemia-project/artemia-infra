#!/bin/bash

# Terraform Import Commands for Artemia Infrastructure (Modular Structure)
# Generated on 2025-07-29
# This script contains all the terraform import commands used to bring existing Azure resources under Terraform management

set -e  # Exit on any error

# Azure Subscription ID
# Get subscription ID from Terraform variable or environment
SUBSCRIPTION_ID=$(terraform output -raw subscription_id 2>/dev/null || echo "${TF_VAR_subscription_id:-$ARM_SUBSCRIPTION_ID}")

echo "Starting Terraform import process for Artemia infrastructure (Modular Structure)..."
echo "Using subscription ID: $SUBSCRIPTION_ID"

# 1. Main Resource Group
echo "Importing main resource group..."
terraform import azurerm_resource_group.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg

# 2. Storage Module Resources
echo "Importing storage module resources..."
terraform import module.storage.azurerm_storage_account.state /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore
terraform import module.storage.azurerm_storage_account.main_data /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiadata
terraform import module.storage.azurerm_storage_container.artemia /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore/blobServices/default/containers/artemia
terraform import module.storage.azurerm_storage_container.tfstate /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore/blobServices/default/containers/terraform-state
terraform import module.storage.azurerm_storage_account_queue_properties.state /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore

# 3. Compute Module Resources
echo "Importing compute module resources..."
terraform import module.compute.azurerm_ssh_public_key.backend /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/sshPublicKeys/artemia-backend-vm-keypair
terraform import module.compute.azurerm_ssh_public_key.llm /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/sshPublicKeys/artemia-llm-vm-keypair
terraform import module.compute.azurerm_ssh_public_key.elasticsearch /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/sshPublicKeys/artemia-elasticsearch-vm-keypair
terraform import module.compute.azurerm_public_ip.backend /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/publicIPAddresses/artemia-backend-vm-ip
terraform import module.compute.azurerm_public_ip.llm /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/publicIPAddresses/artemia-llm-vm-ip
terraform import module.compute.azurerm_public_ip.elasticsearch /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/publicIPAddresses/artemia-elasticsearch-vm-ip
terraform import module.compute.azurerm_network_interface.backend /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-backend-vm-nic
terraform import module.compute.azurerm_network_interface.llm /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-llm-vm-nic
terraform import module.compute.azurerm_network_interface.elasticsearch /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-elasticsearch-vm-nic
terraform import module.compute.azurerm_network_interface_security_group_association.backend "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-backend-vm-nic|/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg"
terraform import module.compute.azurerm_network_interface_security_group_association.llm "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-llm-vm-nic|/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg"
terraform import module.compute.azurerm_network_interface_security_group_association.elasticsearch "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-elasticsearch-vm-nic|/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-elasticsearch-vm-nsg"
terraform import module.compute.azurerm_network_interface_backend_address_pool_association.backend "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-backend-vm-nic/ipConfigurations/ipconfig1|/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/loadBalancers/artemia-load-balancer/backendAddressPools/artemia-backend-pool"
terraform import module.compute.azurerm_network_interface_backend_address_pool_association.llm "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-llm-vm-nic/ipConfigurations/ipconfig1|/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/loadBalancers/artemia-load-balancer/backendAddressPools/artemia-backend-pool"
terraform import module.compute.azurerm_linux_virtual_machine.backend /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/virtualMachines/artemia-backend-vm
terraform import module.compute.azurerm_linux_virtual_machine.llm /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/virtualMachines/artemia-llm-vm
terraform import module.compute.azurerm_linux_virtual_machine.elasticsearch /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/virtualMachines/artemia-elasticsearch-vm

# 4. Network Module Resources
echo "Importing network module resources..."
terraform import module.network.azurerm_virtual_network.vnet /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/virtualNetworks/artemia-vnet
terraform import module.network.azurerm_subnet.default /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/virtualNetworks/artemia-vnet/subnets/default
terraform import module.network.azurerm_subnet.firewall /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/virtualNetworks/artemia-vnet/subnets/AzureFirewallSubnet
terraform import module.network.azurerm_lb.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/loadBalancers/artemia-load-balancer
terraform import module.network.azurerm_lb_backend_address_pool.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/loadBalancers/artemia-load-balancer/backendAddressPools/artemia-backend-pool

# Network Security Groups and Rules
terraform import module.network.azurerm_network_security_group.backend /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg
terraform import module.network.azurerm_network_security_group.llm /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg
terraform import module.network.azurerm_network_security_group.elasticsearch /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-elasticsearch-vm-nsg
terraform import module.network.azurerm_network_security_rule.backend_http /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/HTTP
terraform import module.network.azurerm_network_security_rule.backend_https /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/HTTPS
terraform import module.network.azurerm_network_security_rule.backend_rdp /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/RDP
terraform import module.network.azurerm_network_security_rule.backend_ssh /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/SSH
terraform import module.network.azurerm_network_security_rule.llm_http /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/HTTP
terraform import module.network.azurerm_network_security_rule.llm_https /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/HTTPS
terraform import module.network.azurerm_network_security_rule.llm_rdp /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/RDP
terraform import module.network.azurerm_network_security_rule.llm_ssh /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/SSH
terraform import module.network.azurerm_network_security_rule.elasticsearch_http /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-elasticsearch-vm-nsg/securityRules/HTTP
terraform import module.network.azurerm_network_security_rule.elasticsearch_https /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-elasticsearch-vm-nsg/securityRules/HTTPS
terraform import module.network.azurerm_network_security_rule.elasticsearch_rdp /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-elasticsearch-vm-nsg/securityRules/RDP
terraform import module.network.azurerm_network_security_rule.elasticsearch_ssh /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-elasticsearch-vm-nsg/securityRules/SSH

# 5. Messaging Module Resources (EventHub)
echo "Importing messaging module resources..."
terraform import module.messaging.azurerm_eventhub_namespace.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka
terraform import module.messaging.azurerm_eventhub_namespace_authorization_rule.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/authorizationRules/RootManageSharedAccessKey
terraform import module.messaging.azurerm_eventhub.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/eventhubs/artemia-events
terraform import module.messaging.azurerm_eventhub_consumer_group.default /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/eventhubs/artemia-events/consumerGroups/Default
terraform import module.messaging.azurerm_eventhub_consumer_group.llm_admin /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/eventhubs/artemia-events/consumerGroups/llm.admin
terraform import module.messaging.azurerm_eventhub_consumer_group.llm_user /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/eventhubs/artemia-events/consumerGroups/llm.user

# 6. Database Module Resources
echo "Importing database module resources..."
terraform import module.database.azurerm_mssql_server.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia
terraform import module.database.azurerm_mssql_database.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/databases/artemia
terraform import module.database.azurerm_mssql_server_transparent_data_encryption.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/encryptionProtector/current
terraform import module.database.azurerm_mssql_server_security_alert_policy.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/securityAlertPolicies/Default
terraform import module.database.azurerm_mssql_firewall_rule.allow_all_ips /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/firewallRules/AllowAllIps
terraform import module.database.azurerm_mssql_firewall_rule.allow_azure_services /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/firewallRules/AllowAllWindowsAzureIps
terraform import module.database.azurerm_mssql_virtual_network_rule.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/virtualNetworkRules/artemia-VnetRule
terraform import module.database.azurerm_mssql_database_extended_auditing_policy.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/databases/artemia/extendedAuditingSettings/Default
terraform import module.database.azurerm_mssql_server_extended_auditing_policy.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/extendedAuditingSettings/Default
terraform import module.database.azurerm_mssql_server_microsoft_support_auditing_policy.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/microsoftSupportAuditingPolicies/Default

# 7. Monitoring Module Resources
echo "Importing monitoring module resources..."
terraform import module.monitoring.azurerm_monitor_action_group.main /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/actionGroups/artemia-ag
terraform import module.monitoring.azurerm_monitor_action_group.recommended /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/actionGroups/RecommendedAlertRules-AG-1

# VM Metric Alerts
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_cpu["artemia-backend-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Percentage CPU - artemia-backend-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_cpu["artemia-llm-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Percentage CPU - artemia-llm-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_cpu["artemia-elasticsearch-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Percentage CPU - artemia-elasticsearch-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_memory["artemia-backend-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Available Memory Bytes - artemia-backend-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_memory["artemia-llm-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Available Memory Bytes - artemia-llm-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_memory["artemia-elasticsearch-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Available Memory Bytes - artemia-elasticsearch-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_data_disk_iops["artemia-backend-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Data Disk IOPS Consumed Percentage - artemia-backend-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_data_disk_iops["artemia-llm-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Data Disk IOPS Consumed Percentage - artemia-llm-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_data_disk_iops["artemia-elasticsearch-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Data Disk IOPS Consumed Percentage - artemia-elasticsearch-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_os_disk_iops["artemia-backend-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/OS Disk IOPS Consumed Percentage - artemia-backend-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_os_disk_iops["artemia-llm-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/OS Disk IOPS Consumed Percentage - artemia-llm-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_os_disk_iops["artemia-elasticsearch-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/OS Disk IOPS Consumed Percentage - artemia-elasticsearch-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_network_in["artemia-backend-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network In Total - artemia-backend-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_network_in["artemia-llm-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network In Total - artemia-llm-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_network_in["artemia-elasticsearch-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network In Total - artemia-elasticsearch-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_network_out["artemia-backend-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network Out Total - artemia-backend-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_network_out["artemia-llm-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network Out Total - artemia-llm-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_network_out["artemia-elasticsearch-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network Out Total - artemia-elasticsearch-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_availability["artemia-backend-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/VM Availability - artemia-backend-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_availability["artemia-llm-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/VM Availability - artemia-llm-vm"
terraform import 'module.monitoring.azurerm_monitor_metric_alert.vm_availability["artemia-elasticsearch-vm"]' "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/VM Availability - artemia-elasticsearch-vm"

# 8. AI/ML Module Resources
echo "Importing AI/ML module resources..."
terraform import module.ai_ml.azurerm_cognitive_account.openai /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.CognitiveServices/accounts/artemia-openai

echo "Terraform import process completed successfully!"
echo "Total resources imported: ~70+ resources across all modules"
echo "Next step: Run 'terraform plan' to verify the state"
#!/bin/bash

# Terraform Import Commands for Artemia Infrastructure
# Generated on 2025-07-27
# This script contains all the terraform import commands used to bring existing Azure resources under Terraform management

set -e  # Exit on any error

# Azure Subscription ID
# Get subscription ID from Terraform variable or environment
SUBSCRIPTION_ID=$(terraform output -raw subscription_id 2>/dev/null || echo "${TF_VAR_subscription_id:-$ARM_SUBSCRIPTION_ID}")

echo "Starting Terraform import process for Artemia infrastructure..."
echo "Using subscription ID: $SUBSCRIPTION_ID"

# 1. Basic Resource Group and Storage
echo "Importing basic resource group and storage..."
terraform import azurerm_resource_group.res-0 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg
terraform import azurerm_storage_container.res-116 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore/blobServices/default/containers/artemia
terraform import azurerm_storage_container.res-117 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore/blobServices/default/containers/tfstate

# 2. SSH Public Keys
echo "Importing SSH public keys..."
terraform import azurerm_ssh_public_key.res-5 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/sshPublicKeys/artemia-backend-vm-keypair
terraform import azurerm_ssh_public_key.res-6 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/sshPublicKeys/artemia-llm-vm-keypair
terraform import azurerm_ssh_public_key.res-7 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/sshPublicKeys/elasticsearch-vm-keypair

# 3. EventHub Resources
echo "Importing EventHub resources..."
terraform import azurerm_eventhub_namespace.res-11 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka
terraform import azurerm_eventhub_namespace_authorization_rule.res-12 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/authorizationRules/RootManageSharedAccessKey
terraform import azurerm_eventhub.res-13 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/eventhubs/artemia-events
terraform import azurerm_eventhub_consumer_group.res-15 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/eventhubs/artemia-events/consumergroups/llm.admin
terraform import azurerm_eventhub_consumer_group.res-16 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.EventHub/namespaces/artemia-event-hubs-kafka/eventhubs/artemia-events/consumergroups/llm.user

# 4. Monitor Action Groups
echo "Importing monitor action groups..."
terraform import azurerm_monitor_action_group.res-18 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/actionGroups/artemia-ag
terraform import azurerm_monitor_action_group.res-121 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/actionGroups/RecommendedAlertRules-AG-1

# 5. Monitor Metric Alerts (Available Memory Bytes)
echo "Importing Available Memory Bytes metric alerts..."
terraform import azurerm_monitor_metric_alert.res-19 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Available Memory Bytes - artemia-backend-vm"
terraform import azurerm_monitor_metric_alert.res-20 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Available Memory Bytes - artemia-llm-vm"
terraform import azurerm_monitor_metric_alert.res-21 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Available Memory Bytes - elasticsearch-vm"

# 6. Monitor Metric Alerts (Data Disk IOPS Consumed Percentage)
echo "Importing Data Disk IOPS Consumed Percentage metric alerts..."
terraform import azurerm_monitor_metric_alert.res-22 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Data Disk IOPS Consumed Percentage - artemia-backend-vm"
terraform import azurerm_monitor_metric_alert.res-23 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Data Disk IOPS Consumed Percentage - artemia-llm-vm"
terraform import azurerm_monitor_metric_alert.res-24 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Data Disk IOPS Consumed Percentage - elasticsearch-vm"

# 7. Monitor Metric Alerts (Network In Total)
echo "Importing Network In Total metric alerts..."
terraform import azurerm_monitor_metric_alert.res-25 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network In Total - artemia-backend-vm"
terraform import azurerm_monitor_metric_alert.res-26 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network In Total - artemia-llm-vm"
terraform import azurerm_monitor_metric_alert.res-27 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network In Total - elasticsearch-vm"

# 8. Monitor Metric Alerts (Network Out Total)
echo "Importing Network Out Total metric alerts..."
terraform import azurerm_monitor_metric_alert.res-28 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network Out Total - artemia-backend-vm"
terraform import azurerm_monitor_metric_alert.res-29 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network Out Total - artemia-llm-vm"
terraform import azurerm_monitor_metric_alert.res-30 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Network Out Total - elasticsearch-vm"

# 9. Monitor Metric Alerts (OS Disk IOPS Consumed Percentage)
echo "Importing OS Disk IOPS Consumed Percentage metric alerts..."
terraform import azurerm_monitor_metric_alert.res-31 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/OS Disk IOPS Consumed Percentage - artemia-backend-vm"
terraform import azurerm_monitor_metric_alert.res-32 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/OS Disk IOPS Consumed Percentage - artemia-llm-vm"
terraform import azurerm_monitor_metric_alert.res-33 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/OS Disk IOPS Consumed Percentage - elasticsearch-vm"

# 10. Monitor Metric Alerts (Percentage CPU)
echo "Importing Percentage CPU metric alerts..."
terraform import azurerm_monitor_metric_alert.res-34 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Percentage CPU - artemia-backend-vm"
terraform import azurerm_monitor_metric_alert.res-35 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Percentage CPU - artemia-llm-vm"
terraform import azurerm_monitor_metric_alert.res-36 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/Percentage CPU - elasticsearch-vm"

# 11. Monitor Metric Alerts (VM Availability)
echo "Importing VM Availability metric alerts..."
terraform import azurerm_monitor_metric_alert.res-37 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/VM Availability - artemia-backend-vm"
terraform import azurerm_monitor_metric_alert.res-38 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/VM Availability - artemia-llm-vm"
terraform import azurerm_monitor_metric_alert.res-39 "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Insights/metricAlerts/VM Availability - elasticsearch-vm"

# 12. Load Balancer
echo "Importing load balancer..."
terraform import azurerm_lb.res-40 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/loadBalancers/artemia-load-balancer
terraform import azurerm_lb_backend_address_pool.res-41 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/loadBalancers/artemia-load-balancer/backendAddressPools/artemia-backend-pool

# 13. Network Interfaces
echo "Importing network interfaces..."
terraform import azurerm_network_interface.res-42 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-backend-vm251
terraform import azurerm_network_interface.res-45 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-llm-vm538
terraform import azurerm_network_interface.res-48 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/elasticsearch-vm291

# 14. Network Interface Associations
echo "Importing network interface associations..."
terraform import azurerm_network_interface_backend_address_pool_association.res-43 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-backend-vm251/ipConfigurations/internal/loadBalancerBackendAddressPools/artemia-backend-pool
terraform import azurerm_network_interface_security_group_association.res-44 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-backend-vm251/networkSecurityGroups/artemia-backend-vm-nsg
terraform import azurerm_network_interface_backend_address_pool_association.res-46 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-llm-vm538/ipConfigurations/internal/loadBalancerBackendAddressPools/artemia-backend-pool
terraform import azurerm_network_interface_security_group_association.res-47 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/artemia-llm-vm538/networkSecurityGroups/artemia-llm-vm-nsg
terraform import azurerm_network_interface_security_group_association.res-49 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkInterfaces/elasticsearch-vm291/networkSecurityGroups/elasticsearch-vm-nsg

# 15. Network Security Groups
echo "Importing network security groups..."
terraform import azurerm_network_security_group.res-50 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg
terraform import azurerm_network_security_group.res-55 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg
terraform import azurerm_network_security_group.res-60 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/elasticsearch-vm-nsg

# 16. Network Security Rules - Backend VM NSG
echo "Importing network security rules for backend VM..."
terraform import azurerm_network_security_rule.res-51 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/HTTP
terraform import azurerm_network_security_rule.res-52 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/HTTPS
terraform import azurerm_network_security_rule.res-53 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/RDP
terraform import azurerm_network_security_rule.res-54 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-backend-vm-nsg/securityRules/SSH

# 17. Network Security Rules - LLM VM NSG
echo "Importing network security rules for LLM VM..."
terraform import azurerm_network_security_rule.res-56 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/HTTP
terraform import azurerm_network_security_rule.res-57 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/HTTPS
terraform import azurerm_network_security_rule.res-58 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/RDP
terraform import azurerm_network_security_rule.res-59 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/artemia-llm-vm-nsg/securityRules/SSH

# 18. Network Security Rules - Elasticsearch VM NSG
echo "Importing network security rules for Elasticsearch VM..."
terraform import azurerm_network_security_rule.res-61 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/elasticsearch-vm-nsg/securityRules/HTTP
terraform import azurerm_network_security_rule.res-62 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/elasticsearch-vm-nsg/securityRules/HTTPS
terraform import azurerm_network_security_rule.res-63 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/elasticsearch-vm-nsg/securityRules/RDP
terraform import azurerm_network_security_rule.res-64 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/networkSecurityGroups/elasticsearch-vm-nsg/securityRules/SSH

# 19. Public IP Addresses
echo "Importing public IP addresses..."
terraform import azurerm_public_ip.res-65 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/publicIPAddresses/artemia-backend-vm-ip
terraform import azurerm_public_ip.res-66 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/publicIPAddresses/artemia-llm-vm-ip
terraform import azurerm_public_ip.res-67 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/publicIPAddresses/elasticsearch-vm-ip

# 20. Virtual Network and Subnets
echo "Importing virtual network and subnets..."
terraform import azurerm_virtual_network.res-68 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/virtualNetworks/artemia-vnet
terraform import azurerm_subnet.res-69 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/virtualNetworks/artemia-vnet/subnets/AzureFirewallSubnet
terraform import azurerm_subnet.res-70 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Network/virtualNetworks/artemia-vnet/subnets/default

# 21. SQL Server
echo "Importing SQL Server..."
terraform import azurerm_mssql_server.res-71 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia

# 22. Virtual Machines
echo "Importing virtual machines..."
terraform import azurerm_linux_virtual_machine.res-8 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/virtualMachines/artemia-backend-vm
terraform import azurerm_linux_virtual_machine.res-9 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/virtualMachines/artemia-llm-vm
terraform import azurerm_linux_virtual_machine.res-10 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Compute/virtualMachines/elasticsearch-vm

# 23. Storage Account
echo "Importing storage account..."
terraform import azurerm_storage_account.res-114 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Storage/storageAccounts/artemiastatestore

# 24. SQL Database and Related Resources
echo "Importing SQL database and related resources..."
terraform import azurerm_mssql_database.res-83 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/databases/artemia
terraform import azurerm_mssql_database_extended_auditing_policy.res-89 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/databases/artemia/extendedAuditingSettings/Default
terraform import azurerm_mssql_firewall_rule.res-107 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/firewallRules/AllowAllIps
terraform import azurerm_mssql_firewall_rule.res-108 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/firewallRules/AllowAllWindowsAzureIps
terraform import azurerm_mssql_virtual_network_rule.res-112 /subscriptions/$SUBSCRIPTION_ID/resourceGroups/artemia-rg/providers/Microsoft.Sql/servers/artemia/virtualNetworkRules/artemia-VnetRule

echo "Terraform import process completed successfully!"
echo "Total resources imported: ~65+ resources"
echo "Next step: Run 'terraform plan' to verify the state"
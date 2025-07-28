#!/bin/bash

# RESOURCE_GROUP_NAME=artemia-rg
# STORAGE_ACCOUNT_NAME=artemiastatestore
# CONTAINER_NAME=tfstate

# # Create resource group
# az group create --name $RESOURCE_GROUP_NAME --location koreacentral

# # Create storage account
# az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# # Create blob container
# az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

terraform apply -target=azurerm_storage_account.res-114 -auto-approve
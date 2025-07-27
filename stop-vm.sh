#!/bin/bash

# Azure VM Stop Script
# Usage: ./stop-vm.sh <resource-group> <vm-name>

set -e

# Check if required parameters are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <resource-group> <vm-name>"
    echo "Example: $0 my-resource-group my-vm"
    exit 1
fi

RESOURCE_GROUP="$1"
VM_NAME="$2"

echo "Stopping VM: $VM_NAME in resource group: $RESOURCE_GROUP"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Error: Azure CLI is not installed. Please install it first."
    exit 1
fi

# Check if user is logged in to Azure
if ! az account show &> /dev/null; then
    echo "Error: Not logged in to Azure. Please run 'az login' first."
    exit 1
fi

# Stop the VM
echo "Stopping VM..."
az vm stop --resource-group "$RESOURCE_GROUP" --name "$VM_NAME"

if [ $? -eq 0 ]; then
    echo "✓ VM '$VM_NAME' has been stopped successfully."
    
    # Optionally deallocate the VM to save costs
    read -p "Do you want to deallocate the VM to save costs? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Deallocating VM..."
        az vm deallocate --resource-group "$RESOURCE_GROUP" --name "$VM_NAME"
        if [ $? -eq 0 ]; then
            echo "✓ VM '$VM_NAME' has been deallocated successfully."
        else
            echo "✗ Failed to deallocate VM '$VM_NAME'."
            exit 1
        fi
    fi
else
    echo "✗ Failed to stop VM '$VM_NAME'."
    exit 1
fi
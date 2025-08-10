#!/bin/bash

# Azure VM Start Script
# Usage: ./start-vm.sh <resource-group> <vm-name>

set -e

# Check if required parameters are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <resource-group> <vm-name>"
    echo "Example: $0 my-resource-group my-vm"
    exit 1
fi

RESOURCE_GROUP="$1"
VM_NAME="$2"

echo "Starting VM: $VM_NAME in resource group: $RESOURCE_GROUP"

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

# Check VM status
echo "Checking VM status..."
VM_STATUS=$(az vm get-instance-view --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query "instanceView.statuses[1].displayStatus" --output tsv 2>/dev/null)

if [ $? -ne 0 ]; then
    echo "✗ Failed to get VM status. Please check if the VM exists."
    exit 1
fi

echo "Current VM status: $VM_STATUS"

# Start the VM
case "$VM_STATUS" in
    "VM stopped" | "VM deallocated")
        echo "Starting VM..."
        az vm start --resource-group "$RESOURCE_GROUP" --name "$VM_NAME"
        
        if [ $? -eq 0 ]; then
            echo "✓ VM '$VM_NAME' has been started successfully."
            
            # Wait a moment and show the new status
            echo "Waiting for VM to fully start..."
            sleep 5
            NEW_STATUS=$(az vm get-instance-view --resource-group "$RESOURCE_GROUP" --name "$VM_NAME" --query "instanceView.statuses[1].displayStatus" --output tsv)
            echo "New VM status: $NEW_STATUS"
        else
            echo "✗ Failed to start VM '$VM_NAME'."
            exit 1
        fi
        ;;
    "VM running")
        echo "✓ VM '$VM_NAME' is already running."
        ;;
    *)
        echo "⚠ VM '$VM_NAME' is in an unexpected state: $VM_STATUS"
        echo "You may need to check the VM status in the Azure portal."
        ;;
esac
#!/bin/bash

set -e
cd Terraform/

# Destroy Terraform-managed infrastructure
echo "Destroying Terraform-managed infrastructure..."
terraform destroy -auto-approve

# Clean up generated files
echo "Cleaning up generated files..."
rm -f ../Ansible/inventory.ini

echo "Infrastructure destroyed and cleaned up."

#!/bin/bash

set -e
cd Terraform/

# Destroy Terraform-managed infrastructure
echo "Destroying Terraform-managed infrastructure..."
terraform destroy -auto-approve

# Clean up generated files
echo "Cleaning up generated files..."
rm -f ../Swarm/static_ip.ini

echo "Infrastructure destroyed and cleaned up."

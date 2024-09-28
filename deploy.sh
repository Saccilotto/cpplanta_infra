#!/bin/bash
set -e

# Navigate to Terraform directory and initialize Terraform
echo "Initializing Terraform..."
cd Terraform/
terraform init

# Apply Terraform configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Sleep for instances to boot up
echo "Waiting for instances to boot up..."
sleep 10

# Navigate to Ansible directory and run playbook
echo "Running Ansible playbook..."
cd ../Ansible/

./run.sh

echo "Deployment complete."
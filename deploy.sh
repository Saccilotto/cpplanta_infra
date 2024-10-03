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
sleep 7

cd ..

# Deploy do stack no Docker Swarm
echo "Deploying Docker Swarm stack..."
ansible-playbook -i ./Swarm/static_ip.ini ./Swarm/swarm_setup.yml

sleep 5

# Navigate to Ansible directory and run playbook
echo "Running Ansible playbook..."
./Configuration/run_config.sh

echo "Deployment complete."

#!/bin/bash

set -e

# Set project vars
export $(grep -v '^#' .env | xargs)

# Navigate to Terraform directory and initialize Terraform
echo "Initializing Terraform..."
cd Terraform/
terraform init

# Apply Terraform configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve

cd ..

# Sleep for instances to boot up
echo "Waiting for instances to boot up..."
sleep 7

cd Swarm/

# Deploy do stack no Docker Swarm
echo "Deploying Docker Swarm stack..."
ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i ./static_ip.ini ./swarm_setup.yml

sleep 5

cd ..
cd Configuration/

# Navigate to Ansible directory and run playbook
echo "Running Ansible playbook..."
./run_config.sh

echo "Deployment complete."

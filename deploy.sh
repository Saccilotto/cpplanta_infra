#!/bin/bash
# Nome do arquivo de stack para o Docker Swarm
STACK_FILE="./stack.yml"

# Nome da stack que será utilizada no Docker Swarm
STACK_NAME="CP-Planta"

# Diretório onde o script run.sh do Ansible está localizado
ANSIBLE_DIR="./Configuration"

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
ansible-playbook -i ./staticip.ini swarmsetup.yml

sleep 3

cd ./$ANSIBLE_DIR/

echo "Generating dynamic inventory..."
./generate_inventory.sh

# Navigate to Ansible directory and run playbook
echo "Running Ansible playbook..."

./run.sh

echo "Deployment complete."
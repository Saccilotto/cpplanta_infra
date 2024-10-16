#!/bin/bash

set -e

# Set project vars
export $(grep -v '^#' .env | xargs)

cd Swarm/

# Deploy do stack no Docker Swarm
echo "Deploying Docker Swarm stack..."
ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i ../static_ip.ini ./swarm_setup.yml

sleep 5

cd ../Configuration/

#Navigate to Ansible directory and run playbook
echo "Running Ansible runners playbook..."
#./run_config.sh

cd ..
echo "Deployment complete."

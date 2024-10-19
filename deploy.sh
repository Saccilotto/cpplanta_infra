#!/bin/bash

# Set project vars
export $(grep -v '^#' .env | xargs)

cd Swarm/

# Deploy do stack no Docker Swarm
echo "Deploying Docker Swarm stack..."
ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i ../static_ip.ini ./swarm_setup.yml || echo "Warning: swarm_setup playbook encountered errors."

sleep 5

cd ../Configuration/

#Navigate to Ansible directory and run playbook
#echo "Running Ansible runners playbook..."
#ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i ../static_ip.ini ./runners.yml || echo "Warning: runners playbook encountered errors."

cd ..
echo "Deployment complete."

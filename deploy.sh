#!/bin/bash

# Nome do arquivo de stack para o Docker Swarm
STACK_FILE="./stack.yml"

# Nome da stack que será utilizada no Docker Swarm
STACK_NAME="CP-Planta"

# Diretório onde o script run.sh do Ansible está localizado
ANSIBLE_DIR="./Ansible"

# Deploy do stack no Docker Swarm
echo "Deploying Docker Swarm stack..."
docker stack deploy -c $STACK_FILE $STACK_NAME

# Verificar se o stack foi corretamente provisionado
sleep 10
docker stack ps $STACK_NAME

# Gerar inventário dinâmico
echo "Generating dynamic inventory..."
./Ansible/generate_inventory.sh

# Executar os playbooks do Ansible
echo "Running Ansible playbooks..."
cd ./Ansible
./run.sh

#!/bin/bash

# Nome do arquivo de inventário que será gerado
INVENTORY_FILE="./inventory.ini"

# Limpar o conteúdo do inventário anterior
echo "" > $INVENTORY_FILE

# Recuperar IPs dos nós Docker Swarm que rodam os serviços
generate_inventory() {
    SERVICE_NAME=$1
    echo "[$SERVICE_NAME]" >> $INVENTORY_FILE
    CONTAINERS=$(docker service ps --filter "desired-state=running" --format "{{.Node}}" $SERVICE_NAME)

    for NODE in $CONTAINERS; do
        NODE_IP=$(docker node inspect --format '{{.Status.Addr}}' $NODE)
        echo "$NODE_IP" >> $INVENTORY_FILE
    done
}

# Adicionar as seções do inventário para backend, databasem frontend, runners
generate_inventory "runners"
generate_inventory "database"
generate_inventory "backend"
generate_inventory "frontend"
#!/bin/bash

# Nome do arquivo de inventário que será gerado
INVENTORY_FILE="./inventory.ini"

# Limpar o conteúdo do inventário anterior
echo "" > $INVENTORY_FILE

# Função para recuperar IPs dos containers de um serviço específico
generate_inventory() {
    SERVICE_NAME=$1
    echo "[$SERVICE_NAME]" >> $INVENTORY_FILE
    CONTAINERS=$(docker service ps --filter "desired-state=running" --format "{{.ID}}" $SERVICE_NAME)
    
    for CONTAINER in $CONTAINERS; do
        CONTAINER_ID=$(docker inspect --format '{{.Status.ContainerStatus.ContainerID}}' $CONTAINER)
        CONTAINER_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)
        echo "$CONTAINER_IP" >> $INVENTORY_FILE
    done
}

# Adicionar as seções do inventário para backend, frontend, runners

generate_inventory "runners"
generate_inventory "database"
generate_inventory "backend"
generate_inventory "frontend"

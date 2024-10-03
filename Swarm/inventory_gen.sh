#!/bin/bash

# Nome do arquivo de inventário que será gerado
INVENTORY_FILE="./inventory.ini"

# Limpar o conteúdo do inventário anterior
echo "" > $INVENTORY_FILE

# Função para gerar inventário com base no nome do serviço
generate_inventory() {
    SERVICE_NAME=$1
    echo "[$SERVICE_NAME]" >> $INVENTORY_FILE

    # Obter os nós que estão rodando o serviço
    CONTAINERS=$(docker service ps CP-Planta_$SERVICE_NAME --filter "desired-state=running" --format "{{.Node}}")

    # Verificar se CONTAINERS não está vazio
    if [[ -z "$CONTAINERS" ]]; then
        echo "Nenhum container rodando para o serviço $SERVICE_NAME" >> $INVENTORY_FILE
    else
        # Obter o IP de cada nó e adicioná-lo ao inventário
        for NODE in $CONTAINERS; do
            NODE_IP=$(docker node inspect --format '{{.Status.Addr}}' $NODE)

            # Verificar se o NODE_IP foi capturado corretamente
            if [[ -z "$NODE_IP" ]]; then
                echo "IP não encontrado para o nó $NODE" >> $INVENTORY_FILE
            else
                echo "$NODE_IP" >> $INVENTORY_FILE
            fi
        done
    fi
}

# Adicionar as seções do inventário para backend, database, frontend, runners
generate_inventory "backend"
generate_inventory "database"
generate_inventory "frontend"
generate_inventory "runners"

echo "Inventory generated at $INVENTORY_FILE"

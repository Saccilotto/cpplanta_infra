#!/bin/bash

cd "$PWD"/Swarm

# Caminho do arquivo original gerado pelo Terraform
terraform_inventory="static_ip.ini"  # Substitua pelo nome correto se necessário

# Caminho para o novo arquivo de inventário que será gerado
new_inventory="../Configuration/inventory.ini"

# Ler as linhas completas das seções [manager] e [worker] do arquivo original
vm1_info=$(grep -A 1 '\[manager\]' $terraform_inventory | tail -n 1)
vm2_info=$(grep -A 1 '\[worker\]' $terraform_inventory | tail -n 1)

# Criar novo arquivo de inventário com as informações completas (IPs, usuários e chaves)
cat <<EOL > $new_inventory
[backend]
$vm1_info

[database]
$vm1_info

[frontend]
$vm2_info

[runners]
$vm1_info
$vm2_info
EOL

# Exibir o inventário gerado
echo "Inventário gerado em $new_inventory:"
cat $new_inventory
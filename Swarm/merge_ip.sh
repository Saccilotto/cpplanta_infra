#!/bin/bash

# Caminho do arquivo original gerado pelo Terraform
terraform_inventory="static_ip.ini"  # Substitua pelo nome correto se necessário

# Caminho para o novo arquivo de inventário que será gerado
new_inventory="../Configuration/inventory.ini"

# Ler IPs dinâmicos das seções [vm1] e [vm2]
vm1_ip=$(grep -A 1 '\[manager\]' $terraform_inventory | tail -n 1 | cut -d' ' -f1)
vm2_ip=$(grep -A 1 '\[worker\]' $terraform_inventory | tail -n 1 | cut -d' ' -f1)

# Criar novo arquivo de inventário
cat <<EOL > $new_inventory
[backend]
$vm1_ip

[database]
$vm1_ip

[frontend]
$vm2_ip

[runners]
$vm1_ip
$vm2_ip
EOL

# Exibir o inventário gerado
echo "Inventário gerado em $new_inventory:"
cat $new_inventory
#!/bin/bash

CONFIG_DIR="$PWD/Configuration"

ansible-playbook -i inventory_merged.ini $CONFIG_DIR/runners.yml

ansible-playbook -i inventory_merged.ini $CONFIG_DIR/database.yml

ansible-playbook -i inventory_merged.ini $CONFIG_DIR/backend.yml

ansible-playbook -i inventory_merged.ini $CONFIG_DIR/frontend.yml
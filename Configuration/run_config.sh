#/bin/bash

set -e

# Set project vars
export $(grep -v '^#' ../.env | xargs)

ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i ../static_ip.ini ./runners.yml
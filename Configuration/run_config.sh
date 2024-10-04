#!/bin/bash

#cd "$PWD"/Configuration

ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i inventory.ini ./runners.yml
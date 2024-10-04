#!/bin/bash

cd "$PWD"/Configuration

ansible-playbook -i inventory.ini ./runners.yml

ansible-playbook -i inventory.ini ./database.yml

ansible-playbook -i inventory.ini ./backend.yml
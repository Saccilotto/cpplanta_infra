#!/bin/bash

cd "$PWD"/Configuration

ansible-playbook -i inventory.ini ./runners.yml
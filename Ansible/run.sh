#!/bin/bash

ansible-playbook -i ./inventory.ini runners.yml

ansible-playbook -i ./inventory.ini backend.yml

ansible-playbook -i ./inventory.ini frontend.yml

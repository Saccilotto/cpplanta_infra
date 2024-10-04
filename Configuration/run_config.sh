#!/bin/bash

ANSIBLE_CONFIG=./ansible.cfg ansible-playbook -i inventory.ini ./runners.yml
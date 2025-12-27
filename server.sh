#!/bin/bash

ansible-playbook -i inventory site.yaml --ask-vault-pass

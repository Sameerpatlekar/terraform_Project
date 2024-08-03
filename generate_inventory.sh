#!/bin/bash

# Extract the outputs from Terraform
PUBLIC_IP=$(terraform output -raw public_instance_public_ip)
PRIVATE_IP=$(terraform output -raw private_instance_private_ip)

# Create the Ansible inventory file
cat > inventory.ini <<EOF
[bastion]
${PUBLIC_IP} ansible_user=ubuntu ansible_port=22 ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[private]
${PRIVATE_IP} ansible_user=ubuntu ansible_port=22 ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p ubuntu@${PUBLIC_IP}" -o StrictHostKeyChecking=no' 

EOF

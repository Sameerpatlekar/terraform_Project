**3-tier Infrastructure with Terraform and Ansible**

**Overview**
This project involves creating a scalable and highly available infrastructure on AWS using Terraform for infrastructure provisioning and Ansible for configuration management. The setup includes a VPC with subnets, NAT gateway, internet gateway, EC2 instances, security groups, a load balancer, RDS instance, CloudWatch for monitoring, SNS for notifications, and Route 53 for DNS management. The EC2 instances are configured using Ansible to host a web application with a backend and frontend server setup.

**Prerequisites**
Before proceeding with the infrastructure setup and configuration, ensure the following prerequisites are met on your local Ubuntu machine:
**Create SSH Key Pair:**
    o Generate an SSH key pair and import the public key into your AWS account.
       #ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
**AWS CLI Installation:**
    o Install AWS CLI.
    o Configure AWS CLI with your access key and secret key.
    o Install Terraform.
    o Install Ansible.

    
**Tools and Technologies**
      • Infrastructure Provisioning: Terraform
      • Configuration Management: Ansible, shell scripting
      • Secrets Management: Terraform Vault, Ansible Vault
      • Cloud Provider: AWS
      • Services Used: VPC, EC2, RDS, S3, CloudWatch, SNS, Route 53, Load Balancer

      
**Three-Tier Architecture**
      • **Presentation Tier**: Managed by the frontend server (NGINX) which handles user interaction.
      • **Application Tier**: Managed by the backend server (Apache) which handles business logic.
      •**Data Tier**: Managed by the RDS instance which handles data storage and management.

      
**Infrastructure Setup with Terraform**
**1. VPC Creation**
      o Create a new VPC with CIDR 192.168.0.0/20.
      o Create public and private subnets in different availability zones.
      o Enable auto-assign public IP on the public subnet. 
      o Create and attach an internet gateway to the VPC.
      o Create a route table, add a route to the interne gateway, and associate it with the public subnet
      o Create a NAT gateway in the public subnet and update the route table for the private subnet to route traffic through the NAT gateway.
      
**2. EC2**
      o Launch an EC2 instances in the public and private subnet.
      o Create security groups for the instances with appropriate inbound rules (SSH, HTTP, MYSQL/Aurora, ALL ICMP, Custom TCP on port 8080).
      o Create an Application Load Balancer and configure it to balance traffic to the private instance.
      o Create a launch template and auto-scaling group to manage the EC2 instances in the private subnet.

**1. RDS:**
      o Create parameter groups and subnet groups for RDS.
      o Launch an RDS instance using the created groups

**2. CloudWatch and SNS:**
      o Set up CloudWatch for monitoring and SNS for notifications.
    
**3. Route 53:**
      o Create a Route 53 hosted zone.
      o Add a new A record with a simple routing policy.
      o Create a health check for the DNS.
    
**Configuration Management**

Shell script :
    o I wrote a shell script to create an inventory file with the IP addresses of the running instances.
    o I saved the terraform output in Json format and then I used that output from variable in Ansible playbook.
      
Ansible:
      1. Private and Public Instances Configuration:
            o Use Ansible to install Apache on the backend server (private instance).
            o Store the WAR file of the application in the webappsfolder and the sql-connector.jar file in the lib folder.
            o Configure context.xml
      2. Frontend Configuration:
            o Install Nginx on the frontend server (public instance).
            o Configure Nginx to proxy pass requests to the backend server load balancer DNS.
      3. Database Configuration:
            o Ansible Playbook to Create Database
            o Use the RDS endpoint stored in the JSON file to create a database
      4.Securing Credentials:
            o Use Terraform Vault and Ansible Vault to secure database passwords.

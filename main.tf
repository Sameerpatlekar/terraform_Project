provider "aws" {
  region = "eu-west-2"
}
/*
provider "vault" {
  address = "http://18.220.158.4:8200"
  skip_child_token = true
  

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "2b0e9dfd-e539-c511-c4f7-036804a4664f"
      secret_id = "003ff69a-31f9-bcbc-d83c-d2da8512169c"
    }
  }
  
}

data "vault_kv_secret_v2" "example" {
  mount = "kv" // change it according to your mount
  name  = "data_secret" // change it according to your secret
  
}
*/
module "vpc" {
  source = "./vpc" 
  vpc_cidr = "192.168.0.0/16"
  environment = "Networking"
  public_subnets_cidr = "192.168.1.0/24"
  private_subnets_1_cidr = "192.168.2.0/24"
  private_subnets_2_cidr = "192.168.3.0/24"
  public_availability_zones = "eu-west-2a"
  private_1_availability_zones = "eu-west-2b"
  private_2_availability_zones = "eu-west-2c"
}

module "sg" {
  source = "./security_group"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./ec2"
  ami = "ami-07c1b39b7b3d2525d"
  instance_type = "t2.micro"
  key_name = "public-key"
  public_subnet_id = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id_1
  environment = "production"
  sg_id = module.sg.sg_ids 
}

module "rds" {
  source = "./rds"
  vpc_id = module.vpc.vpc_id
  subnetid_1 = module.vpc.private_subnet_id_1
  subnetid_2 = module.vpc.private_subnet_id_2
  storage = "20"
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  db_username = "admin" #data.vault_kv_secret_v2.example.data["db_username"] 
  db_password = "admin123" #data.vault_kv_secret_v2.example.data["db_password"]   
}

module "alb" {
  source = "./lb"
  vpc_id = module.vpc.vpc_id
  subnetid_1 = module.vpc.private_subnet_id_1
  subnetid_2 = module.vpc.private_subnet_id_2
  security_groups = module.sg.sg_ids 
  intance_id = module.ec2.instance_id_private
}

module "asg" {
  source = "./asg"
  key_name = "public-key"
  security_groups = module.sg.sg_ids 
  private_subnet_id_1 = module.vpc.private_subnet_id_1
  private_subnet_id_2 =  module.vpc.private_subnet_id_2
  instance_id = module.ec2.instance_id_private
  target_group_arn = module.alb.target_group_arn
  depends_on = [null_resource.nginx_setup]
}

module "CloudWatch" {
  source = "./cloudwatch"
  instance_id_private = module.ec2.instance_id_private
  depends_on = [module.asg]
  
}

module "route53"{
  source = "./route53"
  instance_ip_of_public = module.ec2.public_instance_public_ip
  dns_name = "sameer.cloud" 
  depends_on = [module.ec2]
}


resource "null_resource" "wait_for_rds" {
  depends_on = [module.rds]

  provisioner "local-exec" {
    command = "sleep 30" # Wait for 60 seconds, adjust as needed
  }
}


resource "null_resource" "output_value" {
  provisioner "local-exec" {
    command = "bash ${path.module}/generate_inventory.sh && terraform output -json > terraform_outputs.json "
  }
  depends_on = [null_resource.wait_for_rds ]
}

resource "null_resource" "create_database" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini create_database.yml --vault-password-file /home/sameer/vault.pass"
  }
  depends_on = [null_resource.output_value]
}

resource "null_resource" "script_file" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini playbook.yml --vault-password-file /home/sameer/vault.pass"
  }
  depends_on = [null_resource.create_database]
}

resource "null_resource" "nginx_setup_onprivate" {
  provisioner "local-exec" {
    command = " ansible-playbook -i inventory.ini nginx_setup_onprivate.yml"
  }
  depends_on = [null_resource.script_file]
}

resource "null_resource" "nginx_setup" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini nginx_setup.yml"
  }
  depends_on = [null_resource.nginx_setup_onprivate]
}



resource "aws_instance" "frontend" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id  # Assuming the subnet is provided in the VPC
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_id]
  tags = {
    Name = "frontend-instance"
    environment = var.environment
  }
}

resource "aws_instance" "backend" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id  # Assuming the subnet is provided in the VPC
  key_name      = var.key_name
  vpc_security_group_ids = [var.sg_id]
  tags = {
    Name = "backend-instance"
    environment = var.environment
  }
}
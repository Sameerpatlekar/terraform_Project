# Create a security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow inbound traffic to RDS"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a subnet group for the RDS instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = ["${var.subnetid_1}","${var.subnetid_2}"] # Replace with your subnet IDs

  tags = {
    Name = "rds_subnet_group"
  }
}

resource "aws_db_parameter_group" "pg" {
  name        = "my-db-parameter-group"
  family      = "mysql${var.engine_version}"  # Specify the DB engine family (e.g., mysql5.7)
  description = "My custom DB parameter group for MySQL 5.7"

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "wait_timeout"
    value = "600"
  }

  # Add more parameters as needed
}

# Create the RDS instance
resource "aws_db_instance" "rds" {
  allocated_storage    = var.storage  #20
  storage_type         = var.storage_type   #"gp2"
  engine               = var.engine    #"mysql"
  engine_version       = var.engine_version  #"8.0"
  instance_class       = var.instance_class  #"db.t2.micro"
  username             = var.db_username    #"admin"
  password             = var.db_password    #"admin123"  Update with a secure password
  parameter_group_name = aws_db_parameter_group.pg.name #"default.mysql8.0"
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "example-rds-instance"
  }
}

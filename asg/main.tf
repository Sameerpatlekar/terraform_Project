resource "aws_ami_from_instance" "custom_ami" {
  source_instance_id = var.instance_id
  name        = "custom-ami"
  description = "Custom AMI created with Terraform"
}

resource "aws_launch_template" "custom_temp" {
  name_prefix   = "example-"
  image_id      = aws_ami_from_instance.custom_ami.id # Replace with a valid AMI ID
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"
  user_data = base64encode(
              <<-EOF
              #!/bin/bash
              sudo -i
              chmod 777 /opt/tomcat/apache-tomcat-9.0.91/bin/catalina.sh
              ./opt/tomcat/apache-tomcat-9.0.91/bin/catalina.sh start
              cd /root
              systemctl start mariadb
              systemctl enable mariadb
              systemctl start nginx
              systemctl enable nginx
              EOF
  )

  network_interfaces {
    security_groups       = [var.security_groups]
  }
  
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  launch_template {
    id      = aws_launch_template.custom_temp.id
    version = "$Latest"
  }
  vpc_zone_identifier = [var.private_subnet_id_1 , var.private_subnet_id_2]
  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}

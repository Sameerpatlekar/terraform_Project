resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = true
  security_groups    = [var.security_groups]
  subnets            = ["${var.subnetid_1}","${var.subnetid_2}"]  # Change to your subnet IDs
  enable_deletion_protection = false
}

# Create Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"  # Change to your VPC ID

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

# Create Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "register_target" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = var.intance_id
  port             = 80
}
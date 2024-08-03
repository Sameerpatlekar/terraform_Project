resource "aws_route53_zone" "my_domain" {
  name = var.dns_name
}

resource "aws_route53_record" "dns" {
  zone_id = aws_route53_zone.my_domain.zone_id
  name = ""
  type    = "A"
  ttl     = "300"
  records = ["${var.instance_ip_of_public}"]
}

resource "aws_route53_health_check" "example" {
  fqdn              = "${var.dns_name}" # The domain name to check
  port              = 80            # The port to check (80 for HTTP)
  type              = "HTTP"        # The type of health check (HTTP, HTTPS, TCP, etc.)
  resource_path     = "/"           # The path to check on the domain
  request_interval  = 30            # The interval in seconds between each health check
  failure_threshold = 3             # The number of consecutive failures required to mark the endpoint as unhealthy

  tags = {
    Name = "project-health-check"   # Tags for the health check
  }
}

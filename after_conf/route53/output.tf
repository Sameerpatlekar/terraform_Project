output "dns_record_name" {
  value = aws_route53_zone.my_domain.name
}

output "name_servers" {
  value = aws_route53_zone.my_domain.name_servers
}
output "rds_endpoint"{
  value = module.rds.rds_endpoint
}
output "subnet_id_1" {
  value = module.vpc.private_subnet_id_1
}

output "subnet_id_2" {
  value = module.vpc.private_subnet_id_2
}

output "public_instance_public_ip" {
  value = module.ec2.public_instance_public_ip
}

output "private_instance_private_ip" {
  value = module.ec2.private_instance_private_ip
}

/*output "load_balancer_dns" {
  value = module.alb.load_balancer_dns
}

output "dns_record_name" {
  value = module.route53.dns_record_name
}

output "name_servers" {
  value = module.route53.name_servers
}
*/

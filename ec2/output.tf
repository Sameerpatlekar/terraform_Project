output "public_instance_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "private_instance_private_ip" {
  value = aws_instance.backend.private_ip
}

output "instance_id_private" {
  value= aws_instance.backend.id
}

output "instance_id_public" {
  value= aws_instance.frontend.id
}
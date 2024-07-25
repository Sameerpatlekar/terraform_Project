output "sg_ids" {
    value = aws_security_group.allow_all.id
    description = "security group id "
}
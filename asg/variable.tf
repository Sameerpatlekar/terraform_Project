variable "security_groups" {
    type = string
    description = "security_groups id "
}

variable "private_subnet_id_1" {
    type = string
    description = "subnet id "
}

variable "private_subnet_id_2" {
    type = string
    description = "subnet id "
}

variable "instance_id" {
    type = string
    description = "security_groups id "
}

variable "target_group_arn" {
    type = string
    description = "target group arn"
}

variable "key_name" {
  type        = string
  description = "key name"
}

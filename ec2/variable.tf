variable "ami" {
    description = "image of instance"
    type = string
}

variable "instance_type" {
    description = "instance type of instance"
    type = string
}

variable "public_subnet_id" {
    description = "In which subnet, instance is created"
    type = string
}

variable "private_subnet_id" {
    description = "In which subnet, instance is created"
    type = string
}

variable "environment" {
    description = "environment department"
    type = string
}

variable "sg_id" {
    description = "security group id "
    type = string
}

variable "key_name" {
    description = "key name"
    type = string
}
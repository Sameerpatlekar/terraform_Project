variable "vpc_cidr" {
  description = "cidr block"
  type = string
}

variable "environment" {
  description = "environment department"
  type = string
}

variable "public_subnets_cidr" {
  description = "public subnet cidr"
  type = string
}

variable "private_subnets_1_cidr" {
  description = "private subnet cidr"
  type = string
}

variable "private_subnets_2_cidr" {
  description = "private subnet cidr"
  type = string
}

variable "public_availability_zones" {
  description = "public subnet availability zone"
  type = string
}

variable "private_1_availability_zones" {
  description = "private subnet availability zone"
  type = string
}

variable "private_2_availability_zones" {
  description = "private subnet availability zone"
  type = string
}


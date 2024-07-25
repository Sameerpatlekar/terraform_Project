variable "vpc_id" {
  description = "vpc_id"
  type = string
}
  
  
variable "subnetid_1" {
  description = "subnet id "
  type = string
}

variable "subnetid_2" {
  description = "subnet id "
  type = string
}

variable "storage" {
  description = "storage value eg. 20"
  type = string
}


variable "storage_type" {
  description = "storage_type "
  type = string
}


variable "db_username" {
  description = "db username"
  type = string
}

variable "db_password" {
  description = "database password"
  type = string
}

variable "engine" {
  description = "engine name"
  type = string
}


variable "engine_version" {
  description = "engine_version"
  type = string
}


variable "instance_class" {
  description = "instance_class"
  type = string
}








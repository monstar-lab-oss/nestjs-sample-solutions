variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_class" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

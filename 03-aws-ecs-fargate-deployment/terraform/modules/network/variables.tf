variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "env" {
  type        = string
  description = "The environment of the application."
}

variable "vpc_cidr" {
  type        = string
  description = "The vpc cidr block to use."
}

variable "public_subnet_a_cidr" {
  type        = string
  description = "The subnet cidr block to use."
}

variable "public_subnet_c_cidr" {
  type        = string
  description = "The subnet cidr block to use."
}

variable "private_subnet_a_cidr" {
  type        = string
  description = "The subnet cidr block to use."
}

variable "private_subnet_c_cidr" {
  type        = string
  description = "The subnet cidr block to use."
}

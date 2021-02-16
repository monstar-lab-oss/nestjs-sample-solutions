variable "env" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "aws_profile" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "jwt_private_key_base64" {
  type = string
}

variable "jwt_public_key_base64" {
  type = string
}

variable "github_webhook_secret_backend" {
  type = string
}

variable "github_oauth_token" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "github_repo_name_backend" {
  type = string
}

variable "default_admin_user_password" {
  type = string
}

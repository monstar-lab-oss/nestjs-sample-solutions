variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "vpc_id" {
  type = string
}

variable "github_oauth_token" {
  type = string
}

variable "source_version" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "allow_http_from" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "app_env" {
  type    = string
  default = "production"
}

variable "app_port" {
  type    = string
  default = "3000"
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_pass" {
  type = string
}

variable "db_port" {
  type    = string
  default = "3306"
}

variable "db_user" {
  type = string
}

variable "jwt_access_token_exp_in_sec" {
  type    = string
  default = "3600"
}

variable "jwt_refresh_token_exp_in_sec" {
  type    = string
  default = "72000"
}

variable "jwt_private_key_base64" {
  type = string
}

variable "jwt_public_key_base64" {
  type = string
}

variable "github_webhook_secret" {
  type = string
}

variable "default_admin_user_password" {
  type = string
}

variable "github_repo_owner" {
  type = string
}

variable "github_repo_name" {
  type = string
}

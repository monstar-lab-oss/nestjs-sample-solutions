data "aws_kms_alias" "ssm_key" {
  name = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "app_env" {
  name  = "/${var.project_name}/${var.env}/backend/APP_ENV"
  type  = "String"
  value = var.app_env
}

resource "aws_ssm_parameter" "app_port" {
  name  = "/${var.project_name}/${var.env}/backend/APP_PORT"
  type  = "String"
  value = var.app_port
}

resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.project_name}/${var.env}/backend/DB_HOST"
  type  = "SecureString"
  value = var.db_host
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.project_name}/${var.env}/backend/DB_NAME"
  type  = "SecureString"
  value = var.db_name
}

resource "aws_ssm_parameter" "db_pass" {
  name  = "/${var.project_name}/${var.env}/backend/DB_PASS"
  type  = "SecureString"
  value = var.db_pass
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.project_name}/${var.env}/backend/DB_PORT"
  type  = "String"
  value = var.db_port
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/${var.project_name}/${var.env}/backend/DB_USER"
  type  = "SecureString"
  value = var.db_user
}

resource "aws_ssm_parameter" "jwt_access_token_exp_in_sec" {
  name  = "/${var.project_name}/${var.env}/backend/JWT_ACCESS_TOKEN_EXP_IN_SEC"
  type  = "String"
  value = var.jwt_access_token_exp_in_sec
}

resource "aws_ssm_parameter" "jwt_refresh_token_exp_in_sec" {
  name  = "/${var.project_name}/${var.env}/backend/JWT_REFRESH_TOKEN_EXP_IN_SEC"
  type  = "String"
  value = var.jwt_refresh_token_exp_in_sec
}

resource "aws_ssm_parameter" "jwt_private_key_base64" {
  name  = "/${var.project_name}/${var.env}/backend/JWT_PRIVATE_KEY_BASE64"
  type  = "SecureString"
  value = var.jwt_private_key_base64
}

resource "aws_ssm_parameter" "jwt_public_key_base64" {
  name  = "/${var.project_name}/${var.env}/backend/JWT_PUBLIC_KEY_BASE64"
  type  = "SecureString"
  value = var.jwt_public_key_base64
}

resource "aws_ssm_parameter" "github_webhook_secret" {
  name  = "/${var.project_name}/${var.env}/backend/GITHUB_WEBHOOK_SECRET"
  type  = "SecureString"
  value = var.github_webhook_secret
}

resource "aws_ssm_parameter" "default_admin_user_password" {
  name  = "/${var.project_name}/${var.env}/backend/DEFAULT_ADMIN_USER_PASSWORD"
  type  = "String"
  value = var.default_admin_user_password
}

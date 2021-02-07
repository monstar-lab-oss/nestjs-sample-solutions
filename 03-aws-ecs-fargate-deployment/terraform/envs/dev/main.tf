provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "github" {
  token        = var.github_oauth_token
  organization = var.github_organization
}

module "network" {
  source                = "../../modules/network"
  env                   = var.env
  project_name          = var.project_name
  aws_region            = var.aws_region
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_a_cidr  = "10.0.1.0/24"
  public_subnet_c_cidr  = "10.0.2.0/24"
  private_subnet_a_cidr = "10.0.3.0/24"
  private_subnet_c_cidr = "10.0.4.0/24"
}

module "database" {
  source         = "../../modules/database"
  env            = var.env
  project_name   = var.project_name
  username       = var.db_username
  password       = var.db_password
  db_name        = var.db_name
  vpc_id         = module.network.vpc_id
  instance_class = "db.t3.small"
  subnet_ids     = [module.network.private_subnet_a_id, module.network.private_subnet_c_id]
}

module "backend" {
  source                      = "../../modules/backend"
  env                         = var.env
  project_name                = var.project_name
  vpc_id                      = module.network.vpc_id
  source_version              = "develop"
  private_subnet_ids          = [module.network.private_subnet_a_id, module.network.private_subnet_c_id]
  public_subnet_ids           = [module.network.public_subnet_a_id, module.network.public_subnet_c_id]
  github_oauth_token          = var.github_oauth_token
  depends_on                  = [module.database]
  db_host                     = module.database.endpoint
  db_name                     = var.db_name
  db_user                     = var.db_username
  db_pass                     = var.db_password
  jwt_private_key_base64      = var.jwt_private_key_base64
  jwt_public_key_base64       = var.jwt_public_key_base64
  github_webhook_secret       = var.github_webhook_secret_backend
  default_admin_user_password = var.default_admin_user_password
  github_repo_name            = var.github_repo_name_backend
  github_repo_owner           = var.github_organization
}

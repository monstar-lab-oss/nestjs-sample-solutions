terraform {
  required_version = ">= 0.13.5"

  backend "s3" {
    bucket         = "ml-nestjs-starter-tfstate"
    key            = "dev.terraform.tfstate"
    encrypt        = true
    dynamodb_table = "tf-state-lock"
    region         = "ap-northeast-1"
    profile        = "ml-nestjs-starter"
  }
}

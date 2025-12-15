# AWS Provider를 Terraform이 다운로드하도록 설정
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region  = var.aws_region
}

module "component" {
  source      = "./component"
  environment = var.environment
  enable      = var.environment == "sandbox" ? var.enable_sandbox : true
}

# module "discord-bot" {
#   source             = "./discord-bot/infra"
#   count              = var.environment == "sandbox" ? 1 : 0
#   environment        = var.environment
#   discord_public_key = var.discord_public_key
#   github_token       = var.github_token
# }

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
  profile = var.aws_profile
  region  = var.aws_region
}

module "component" {
  source      = "./component"
  environment = var.environment
  enable      = var.environment == "sandbox" ? var.enable_sandbox : true

  instance_type        = var.instance_type
  ecs_desired_capacity = var.ecs_desired_capacity
  ecs_min_size         = var.ecs_min_size
  ecs_max_size         = var.ecs_max_size

  ssh_ingress_cidrs = var.ssh_ingress_cidrs
  app_ingress_cidrs = var.app_ingress_cidrs

  container_image_tag = var.container_image_tag
  container_port      = var.container_port
}

# module "discord-bot" {
#   source             = "./discord-bot/infra"
#   count              = var.environment == "sandbox" ? 1 : 0
#   environment        = var.environment
#   discord_public_key = var.discord_public_key
#   github_token       = var.github_token
# }

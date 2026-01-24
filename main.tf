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

  ssh_ingress_cidrs = var.ssh_ingress_cidrs
  app_ingress_cidrs = var.app_ingress_cidrs

  container_image_tag = var.container_image_tag
  container_port      = var.container_port
}

moved {
  from = module.component.module.ecs_ec2.aws_route53_zone.primary[0]
  to   = module.component.module.prod.aws_route53_zone.primary[0]
}

moved {
  from = module.component.module.ecs_ec2.aws_acm_certificate.alb[0]
  to   = module.component.module.prod.aws_acm_certificate.alb[0]
}

moved {
  from = module.component.module.ecs_ec2.aws_route53_record.cert_validation
  to   = module.component.module.prod.aws_route53_record.cert_validation
}

moved {
  from = module.component.module.ecs_ec2.aws_acm_certificate_validation.alb[0]
  to   = module.component.module.prod.aws_acm_certificate_validation.alb[0]
}

moved {
  from = module.component.module.ecs_ec2.aws_lb_listener.nomoney_https[0]
  to   = module.component.module.prod.aws_lb_listener.nomoney_https[0]
}

moved {
  from = module.component.module.ecs_ec2.aws_route53_record.alb_alias[0]
  to   = module.component.module.prod.aws_route53_record.alb_alias[0]
}

# module "discord-bot" {
#   source             = "./discord-bot/infra"
#   count              = var.environment == "sandbox" ? 1 : 0
#   environment        = var.environment
#   discord_public_key = var.discord_public_key
#   github_token       = var.github_token
# }

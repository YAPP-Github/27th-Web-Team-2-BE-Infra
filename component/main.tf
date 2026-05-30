module "ecr" {
  source      = "./ecr"
  environment = var.environment
}

# Legacy ECS on EC2 runtime. Kept commented so it can be restored later.
# module "ecs_ec2" {
#   source = "./ecs-ec2"
#
#   environment = var.environment
#
#   vpc_id = aws_vpc.main.id
#   public_subnet_ids = [
#     aws_subnet.public_a.id,
#     aws_subnet.public_c.id
#   ]
#
#   instance_type = var.instance_type
#
#   ssh_ingress_cidrs = var.ssh_ingress_cidrs
#   app_ingress_cidrs = var.app_ingress_cidrs
#
#   container_image = "${module.ecr.repository_url}:${var.container_image_tag}"
#   container_port  = var.container_port
# }

module "prod" {
  source = "./prod"

  environment = var.environment

  # Legacy ALB inputs. Lambda-only mode no longer depends on ECS/ALB outputs.
  # alb_arn          = module.ecs_ec2.nomoney_alb_arn
  # alb_dns_name     = module.ecs_ec2.nomoney_alb_dns_name
  # alb_zone_id      = module.ecs_ec2.nomoney_alb_zone_id
  # target_group_arn = module.ecs_ec2.nomoney_tg_arn

  enable_lambda_api                    = var.enable_lambda_api
  route_primary_api_to_lambda          = var.route_primary_api_to_lambda
  lambda_image_uri                     = "${module.ecr.lambda_repository_url}:${var.lambda_image_tag}"
  lambda_memory_size                   = var.lambda_memory_size
  lambda_timeout                       = var.lambda_timeout
  lambda_alias_name                    = var.lambda_alias_name
  lambda_provisioned_concurrency       = var.lambda_provisioned_concurrency
  lambda_keep_warm_enabled             = var.lambda_keep_warm_enabled
  lambda_keep_warm_schedule_expression = var.lambda_keep_warm_schedule_expression
  lambda_architectures                 = var.lambda_architectures
  lambda_container_port                = var.container_port
}

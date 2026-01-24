module "ecr" {
  source      = "./ecr"
  environment = var.environment
}

module "ecs_ec2" {
  source = "./ecs-ec2"

  environment = var.environment

  vpc_id            = aws_vpc.main.id
  public_subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]

  instance_type        = var.instance_type

  ssh_ingress_cidrs = var.ssh_ingress_cidrs
  app_ingress_cidrs = var.app_ingress_cidrs

  container_image = "${module.ecr.repository_url}:${var.container_image_tag}"
  container_port  = var.container_port
}

module "prod" {
  source = "./prod"

  environment = var.environment

  alb_arn         = module.ecs_ec2.nomoney_alb_arn
  alb_dns_name    = module.ecs_ec2.nomoney_alb_dns_name
  alb_zone_id     = module.ecs_ec2.nomoney_alb_zone_id
  target_group_arn = module.ecs_ec2.nomoney_tg_arn
}

module "ecr" {
  source      = "./ecr"
  environment = "sandbox"
}

module "ecs_ec2" {
  source = "./ecs-ec2"

  environment = "sandbox"

  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids

  instance_type         = "t3.micro"
  ecs_desired_capacity  = 1
  ecs_min_size          = 1
  ecs_max_size          = 1

  # Sandbox용 임시 설정
  ssh_ingress_cidrs = ["0.0.0.0/0"]
  app_ingress_cidrs = ["0.0.0.0/0"]

  # 이미지 지정, 태그: bootstrap
  container_image = "${module.ecr.repository_url}:bootstrap"
  container_port  = 80
}
#####################################
# ECR module 이동
#####################################
moved {
  from = module.component.module.sandbox[0].module.ecr
  to   = module.component.module.ecr
}

#####################################
# ECS EC2 module 이동
#####################################
moved {
  from = module.component.module.sandbox[0].module.ecs_ec2
  to   = module.component.module.ecs_ec2
}
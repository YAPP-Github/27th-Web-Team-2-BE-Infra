resource "aws_ecs_capacity_provider" "ecs_cluster_ec2_cp" {
  name = "${var.environment}-ecs-cluster-ec2-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.platform_ec2_asg.arn

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
    }

    managed_termination_protection = "DISABLED"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_default_cp" {
  cluster_name       = aws_ecs_cluster.platform_ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_cluster_ec2_cp.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_cluster_ec2_cp.name
    weight            = 1
    base              = 1
  }
}

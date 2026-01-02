resource "aws_ecs_capacity_provider" "cluster_ec2_shared" {
  name = "${var.environment}-cluster-ec2-shared-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.cluster_ec2_shared_asg.arn

    managed_scaling {
      status                    = "DISABLED" # sandbox: 1대 고정 (나중에 필요하면 ENABLED로)
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1
    }

    managed_termination_protection = "DISABLED"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_default_ec2" {
  cluster_name       = aws_ecs_cluster.cluster_shared.name
  capacity_providers = [aws_ecs_capacity_provider.cluster_ec2_shared.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.cluster_ec2_shared.name
    weight            = 1
    base              = 1
  }
}
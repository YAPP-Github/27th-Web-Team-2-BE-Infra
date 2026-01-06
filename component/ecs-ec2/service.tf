data "aws_ecs_task_definition" "nomoney_task_definition" {
  task_definition = "${var.environment}-app"
}

resource "aws_ecs_service" "nomoney_api" {
  name            = "${var.environment}-app-svc"
  cluster         = aws_ecs_cluster.platform_ecs_cluster.id
  task_definition = data.aws_ecs_task_definition.nomoney_task_definition.arn
  desired_count   = 1

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  health_check_grace_period_seconds = 300

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_cluster_ec2_cp.name
    weight            = 1
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  depends_on = [
    aws_ecs_cluster_capacity_providers.ecs_cluster_default_cp
  ]
}
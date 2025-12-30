resource "aws_ecs_service" "app" {
  name            = "${var.environment}-app-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  health_check_grace_period_seconds = 300

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs.name
    weight            = 1
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  depends_on = [
    aws_ecs_cluster_capacity_providers.this
  ]
}
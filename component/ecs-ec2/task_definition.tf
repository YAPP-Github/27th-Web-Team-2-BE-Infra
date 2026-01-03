resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.environment}/app"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "nomoney_app_log" {
  name              = "/ecs/${var.environment}/app"
  retention_in_days = 7
}
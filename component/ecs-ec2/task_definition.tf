resource "aws_cloudwatch_log_group" "schedule_vote" {
  name              = "/ecs/${var.environment}/app"
  retention_in_days = 7
}
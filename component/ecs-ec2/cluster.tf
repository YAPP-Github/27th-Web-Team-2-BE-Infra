resource "aws_ecs_cluster" "platform_ecs_cluster" {
  name = "${var.environment}-ecs-cluster"
}
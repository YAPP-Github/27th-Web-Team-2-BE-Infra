resource "aws_ecs_cluster" "cluster_shared" {
  name = "${var.environment}-ecs-cluster"
}
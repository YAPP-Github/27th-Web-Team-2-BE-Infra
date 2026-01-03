resource "aws_cloudwatch_log_group" "nomoney_app_log" {
  name              = "/ecs/${var.environment}/app"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app_placeholder" {
  family                   = "${var.environment}-app"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = tostring(var.cpu)
  memory                   = tostring(var.memory)

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  # NOTE:
  # Terraform plan/apply 성공을 위한 placeholder task definition.
  # 실제 배포 시에는 CI/CD 워크플로우에서 생성한 revision이 사용된다.
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 0
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nomoney_app_log.name
          awslogs-region        = "ap-northeast-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
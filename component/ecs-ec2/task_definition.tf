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
  volume {
    name = "app-logs-volume"
  }

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

      environment = [
        { name = "LOG_PATH", value = "/var/log/app" }
      ]

      mountPoints = [
        {
          sourceVolume  = "app-logs-volume"
          containerPath = "/var/log/app"
          readOnly      = false
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
    },
    {
      name      = "grafana-agent"
      image     = "grafana/agent:v0.40.5"
      essential = false
      links     = ["app"]

      mountPoints = [
        {
          sourceVolume  = "app-logs-volume"
          containerPath = "/var/log/app"
          readOnly      = true
        }
      ]

      secrets = [
        { name = "GRAFANA_CLOUD_API_KEY",   valueFrom = "arn:aws:ssm:ap-northeast-2:264015108625:parameter/nomoney/sandbox/grafana/api-key" },
        { name = "GRAFANA_CLOUD_PROM_USER", valueFrom = "arn:aws:ssm:ap-northeast-2:264015108625:parameter/nomoney/sandbox/grafana/prometheus-user" },
        { name = "GRAFANA_CLOUD_LOKI_USER", valueFrom = "arn:aws:ssm:ap-northeast-2:264015108625:parameter/nomoney/sandbox/grafana/loki-user" }
      ],

      environment = [
        { name = "GRAFANA_CLOUD_PROM_URL", value = "https://prometheus-prod-49-prod-ap-northeast-0.grafana.net/api/prom/push" },
        { name = "GRAFANA_CLOUD_LOKI_URL", value = "https://logs-prod-030.grafana.net/loki/api/v1/push" },

        {
          name = "AGENT_CONFIG_CONTENT",
          value = <<EOF
metrics:
  global:
    scrape_interval: 15s
  # [수정] configs는 global과 같은 레벨이어야 함
  configs:
    - name: default
      scrape_configs:
        - job_name: app
          metrics_path: /actuator/prometheus
          static_configs:
            - targets: ['app:${var.container_port}']
      remote_write:
        - url: $${GRAFANA_CLOUD_PROM_URL}
          basic_auth:
            username: $${GRAFANA_CLOUD_PROM_USER}
            password: $${GRAFANA_CLOUD_API_KEY}

logs:
  configs:
    - name: default
      clients:
        - url: $${GRAFANA_CLOUD_LOKI_URL}
          basic_auth:
            username: $${GRAFANA_CLOUD_LOKI_USER}
            password: $${GRAFANA_CLOUD_API_KEY}
      positions:
        filename: /tmp/positions.yaml
      scrape_configs:
        - job_name: app-logs
          static_configs:
            - targets: ['localhost']
              labels:
                job: app
                # 피드백: ** 패턴이 동작하지 않을 경우 /var/log/app/*/*.log 로 변경 고려
                __path__: /var/log/app/**/*.log
EOF
        }
      ],

      entryPoint = ["/bin/sh", "-c"],
      command    = ["echo \"$AGENT_CONFIG_CONTENT\" > /etc/agent.yaml && /bin/grafana-agent -config.file=/etc/agent.yaml"]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.nomoney_app_log.name
          awslogs-region        = "ap-northeast-2"
          awslogs-stream-prefix = "grafana-agent"
        }
      }
    }
  ])
}

# 현재 실행 중인 AWS 계정 정보를 가져오는 Data Source
data "aws_caller_identity" "current" {}

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
        {
          name = "GRAFANA_CLOUD_API_KEY",
          valueFrom = "arn:aws:ssm:ap-northeast-2:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/nomoney/grafana/api-key"
        },
        {
          name = "GRAFANA_CLOUD_PROM_USER",
          valueFrom = "arn:aws:ssm:ap-northeast-2:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/nomoney/grafana/prometheus-user"
        },
        {
          name = "GRAFANA_CLOUD_LOKI_USER",
          valueFrom = "arn:aws:ssm:ap-northeast-2:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/nomoney/grafana/loki-user"
        },
        {
          name = "GRAFANA_CLOUD_PROM_URL",
          valueFrom = "arn:aws:ssm:ap-northeast-2:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/nomoney/grafana/prometheus-url"
        },
        {
          name = "GRAFANA_CLOUD_LOKI_URL",
          valueFrom = "arn:aws:ssm:ap-northeast-2:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/nomoney/grafana/loki-url"
        }
      ],

      environment = [
        {
          name = "AGENT_CONFIG_CONTENT",
          value = <<EOF
metrics:
  global:
    scrape_interval: 15s
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
        # 1. Console 로그 수집
        - job_name: app-logs
          static_configs:
            - targets: ['localhost']
              labels:
                job: app
                log_type: console
                __path__: /var/log/app/console/*.log

        # 2. Transaction(API) 로그 수집
        - job_name: app-transaction
          static_configs:
            - targets: ['localhost']
              labels:
                job: app
                log_type: transaction
                __path__: /var/log/app/api/*.log
EOF
        }
      ],

      entryPoint = ["/bin/sh", "-c"],
      command    = ["echo \"$AGENT_CONFIG_CONTENT\" > /etc/agent.yaml && /bin/grafana-agent -config.file=/etc/agent.yaml -config.expand-env"]

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

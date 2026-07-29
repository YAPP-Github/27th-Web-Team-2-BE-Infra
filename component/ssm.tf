# ===== DB =====
resource "aws_ssm_parameter" "db_url" {
  name  = "/${var.environment}/nomoney/api/DB_URL"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.environment}/nomoney/api/DB_USERNAME"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.environment}/nomoney/api/DB_PASSWORD"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

# ===== AWS =====
resource "aws_ssm_parameter" "aws_access_key" {
  name  = "/${var.environment}/nomoney/api/AWS_ACCESS_KEY"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "aws_secret_key" {
  name  = "/${var.environment}/nomoney/api/AWS_SECRET_KEY"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

# ===== Auth / 인증 =====
resource "aws_ssm_parameter" "google_client_id" {
  name  = "/${var.environment}/nomoney/api/GOOGLE_CLIENT_ID"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "google_client_secret" {
  name  = "/${var.environment}/nomoney/api/GOOGLE_CLIENT_SECRET"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "google_redirect_uri" {
  name  = "/${var.environment}/nomoney/api/GOOGLE_REDIRECT_URI"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "kakao_client_id" {
  name  = "/${var.environment}/nomoney/api/KAKAO_CLIENT_ID"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "kakao_client_secret" {
  name  = "/${var.environment}/nomoney/api/KAKAO_CLIENT_SECRET"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "kakao_redirect_uri" {
  name  = "/${var.environment}/nomoney/api/KAKAO_REDIRECT_URI"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

# ===== Sentry =====
resource "aws_ssm_parameter" "sentry_dsn" {
  name  = "/${var.environment}/nomoney/api/sentry.dsn"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

# ===== Grafana =====
resource "aws_ssm_parameter" "grafana_api_key" {
  name  = "/${var.environment}/nomoney/grafana/api-key"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "grafana_prometheus_url" {
  name  = "/${var.environment}/nomoney/grafana/prometheus-url"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "grafana_prometheus_user" {
  name  = "/${var.environment}/nomoney/grafana/prometheus-user"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "grafana_loki_url" {
  name  = "/${var.environment}/nomoney/grafana/loki-url"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "grafana_loki_user" {
  name  = "/${var.environment}/nomoney/grafana/loki-user"
  type  = "String"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }
}
############################
# Spring Boot 애플리케이션용 IAM 사용자
#
# ECS Task 위에서 동작하는 Spring Boot가
# - Parameter Store 조회
# - CloudWatch Logs 기록
# 을 하기 위해 사용하는 정적 자격 증명이다.
############################
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  app_parameter_path = "/${var.environment}/nomoney/api"

  app_parameter_arns = [
    "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.app_parameter_path}",
    "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.app_parameter_path}/*",
  ]

  # aws_cloudwatch_log_group.arn 은 뒤에 ":*" 가 붙어 있어 그대로 이어 붙이면
  # log-stream ARN 이 깨지므로 제거한 형태를 기준으로 사용한다.
  app_log_group_arns = [
    trimsuffix(aws_cloudwatch_log_group.nomoney_transaction_log.arn, ":*"),
    trimsuffix(aws_cloudwatch_log_group.nomoney_console_log.arn, ":*"),
  ]
}

resource "aws_iam_user" "app" {
  name = "${var.environment}-nomoney-app"

  tags = {
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "app" {
  # Parameter Store 조회
  statement {
    sid = "ReadAppParameters"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = local.app_parameter_arns
  }

  # SecureString 파라미터 복호화 (기본 키 사용 시)
  statement {
    sid = "DecryptAppParameters"

    actions = ["kms:Decrypt"]

    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/aws/ssm"
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["ssm.${data.aws_region.current.name}.amazonaws.com"]
    }
  }

  # CloudWatch Logs 기록
  statement {
    sid = "WriteAppLogs"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = concat(
      [for arn in local.app_log_group_arns : "${arn}:*"],
      [for arn in local.app_log_group_arns : "${arn}:log-stream:*"]
    )
  }

  # CloudWatch 로그 라이브러리가 기동 시 로그 그룹 존재 여부를 확인한다.
  # DescribeLogGroups는 리소스 단위 제한을 지원하지 않아 * 로 지정한다.
  statement {
    sid       = "DescribeLogGroups"
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "app" {
  name   = "${var.environment}-nomoney-app-policy"
  user   = aws_iam_user.app.name
  policy = data.aws_iam_policy_document.app.json
}

resource "aws_iam_access_key" "app" {
  user = aws_iam_user.app.name
}

# Lambda 기반 API 테스트 경로를 구성하는 런타임 리소스
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_api" {
  count = local.enable_lambda_api ? 1 : 0

  name               = "${var.environment}-app-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  count = local.enable_lambda_api ? 1 : 0

  role       = aws_iam_role.lambda_api[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_ssm_readonly" {
  count = local.enable_lambda_api ? 1 : 0

  role       = aws_iam_role.lambda_api[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_cloudwatch_log_group" "lambda_api" {
  count = local.enable_lambda_api ? 1 : 0

  name              = "/aws/lambda/${var.environment}-app-lambda"
  retention_in_days = 14

  tags = {
    Environment = var.environment
  }
}

resource "aws_lambda_function" "api" {
  count = local.enable_lambda_api ? 1 : 0

  function_name = "${var.environment}-app-lambda"
  package_type  = "Image"
  image_uri     = var.lambda_image_uri
  role          = aws_iam_role.lambda_api[0].arn
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  architectures = var.lambda_architectures
  publish       = true

  environment {
    variables = {
      AWS_LWA_PORT                 = tostring(var.lambda_container_port)
      AWS_LWA_READINESS_CHECK_PATH = "/ping"
      LOG_PATH                     = "/tmp/app"
      SPRING_PROFILES_ACTIVE       = var.environment
    }
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_api,
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy_attachment.lambda_ssm_readonly
  ]

  tags = {
    Environment = var.environment
  }
}

# Lambda 함수를 HTTP API와 테스트 도메인에 연결하는 리소스
resource "aws_apigatewayv2_api" "lambda_api" {
  count = local.enable_lambda_api ? 1 : 0

  name          = "${var.environment}-app-lambda-http-api"
  protocol_type = "HTTP"

  tags = {
    Environment = var.environment
  }
}

resource "aws_apigatewayv2_integration" "lambda_api" {
  count = local.enable_lambda_api ? 1 : 0

  api_id                 = aws_apigatewayv2_api.lambda_api[0].id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api[0].invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
  timeout_milliseconds   = 30000
}

resource "aws_apigatewayv2_route" "lambda_default" {
  count = local.enable_lambda_api ? 1 : 0

  api_id    = aws_apigatewayv2_api.lambda_api[0].id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_api[0].id}"
}

resource "aws_apigatewayv2_stage" "lambda_default" {
  count = local.enable_lambda_api ? 1 : 0

  api_id      = aws_apigatewayv2_api.lambda_api[0].id
  name        = "$default"
  auto_deploy = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_lambda_permission" "api_gateway" {
  count = local.enable_lambda_api ? 1 : 0

  statement_id  = "AllowExecutionFromHttpApi"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api[0].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api[0].execution_arn}/*/*"
}

resource "aws_apigatewayv2_domain_name" "lambda_primary" {
  count = local.enable_lambda_api ? 1 : 0

  domain_name = local.lambda_primary_domain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.lambda_api[0].certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_apigatewayv2_domain_name" "lambda_secondary" {
  count = local.enable_lambda_api ? 1 : 0

  domain_name = local.lambda_secondary_domain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.lambda_api[0].certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_apigatewayv2_api_mapping" "lambda_primary" {
  count = local.enable_lambda_api ? 1 : 0

  api_id      = aws_apigatewayv2_api.lambda_api[0].id
  domain_name = aws_apigatewayv2_domain_name.lambda_primary[0].domain_name
  stage       = aws_apigatewayv2_stage.lambda_default[0].name
}

resource "aws_apigatewayv2_api_mapping" "lambda_secondary" {
  count = local.enable_lambda_api ? 1 : 0

  api_id      = aws_apigatewayv2_api.lambda_api[0].id
  domain_name = aws_apigatewayv2_domain_name.lambda_secondary[0].domain_name
  stage       = aws_apigatewayv2_stage.lambda_default[0].name
}

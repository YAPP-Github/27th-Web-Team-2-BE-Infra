# prod 모듈에서 테스트용 Lambda API 정보를 노출하는 출력값
output "lambda_api_endpoint" {
  description = "Default HTTP API endpoint for the Lambda test path"
  value       = local.enable_lambda_api ? aws_apigatewayv2_api.lambda_api[0].api_endpoint : null
}

output "lambda_primary_domain" {
  description = "Primary Lambda test domain"
  value       = local.enable_lambda_api ? local.lambda_primary_domain : null
}

output "lambda_secondary_domain" {
  description = "Secondary Lambda test domain"
  value       = local.enable_lambda_api ? local.lambda_secondary_domain : null
}

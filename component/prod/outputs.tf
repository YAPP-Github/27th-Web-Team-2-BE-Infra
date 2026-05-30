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

output "lambda_alias_name" {
  description = "Lambda alias used by API Gateway"
  value       = local.enable_lambda_api ? aws_lambda_alias.api_live[0].name : null
}

output "lambda_provisioned_concurrency" {
  description = "Provisioned concurrency configured for the Lambda API alias"
  value       = local.enable_lambda_api ? var.lambda_provisioned_concurrency : null
}

output "lambda_keep_warm_schedule_expression" {
  description = "EventBridge schedule used to keep the Lambda API alias warm"
  value       = local.enable_lambda_api && var.lambda_keep_warm_enabled ? var.lambda_keep_warm_schedule_expression : null
}

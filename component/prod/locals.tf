locals {
  enable_custom_domain        = contains(["prod", "sandbox"], var.environment)
  enable_lambda_api           = local.enable_custom_domain
  route_primary_api_to_lambda = local.enable_lambda_api
  # Legacy parallel-mode gates. Lambda-only mode keeps the API path enabled.
  # enable_lambda_api           = local.enable_custom_domain && var.enable_lambda_api
  # route_primary_api_to_lambda = local.enable_lambda_api && var.route_primary_api_to_lambda
  primary_zone_name       = var.environment == "prod" ? "moit.kr" : "sandbox-api.moit.kr"
  secondary_zone_name     = var.environment == "prod" ? "weddin.kr" : "sandbox-api.weddin.kr"
  alb_primary_domain      = var.environment == "prod" ? "api.moit.kr" : "sandbox-api.moit.kr"
  alb_secondary_domain    = var.environment == "prod" ? "api.weddin.kr" : "sandbox-api.weddin.kr"
  lambda_primary_domain   = var.environment == "prod" ? "lambda-api.moit.kr" : "lambda-api.sandbox-api.moit.kr"
  lambda_secondary_domain = var.environment == "prod" ? "lambda-api.weddin.kr" : "lambda-api.sandbox-api.weddin.kr"

  cert_validation_zone_by_domain = local.enable_custom_domain ? {
    (local.alb_primary_domain)      = aws_route53_zone.primary[0].zone_id
    (local.alb_secondary_domain)    = aws_route53_zone.secondary[0].zone_id
    (local.lambda_primary_domain)   = aws_route53_zone.primary[0].zone_id
    (local.lambda_secondary_domain) = aws_route53_zone.secondary[0].zone_id
  } : {}
}

locals {
  enable_custom_domain = contains(["prod", "sandbox"], var.environment)
  primary_zone_name    = var.environment == "prod" ? "moit.kr" : "sandbox-api.moit.kr"
  secondary_zone_name  = var.environment == "prod" ? "weddin.kr" : "sandbox-api.weddin.kr"
  alb_primary_domain   = var.environment == "prod" ? "api.moit.kr" : "sandbox-api.moit.kr"
  alb_secondary_domain = var.environment == "prod" ? "api.weddin.kr" : "sandbox-api.weddin.kr"

  cert_validation_zone_by_domain = local.enable_custom_domain ? {
    (local.alb_primary_domain)   = aws_route53_zone.primary[0].zone_id
    (local.alb_secondary_domain) = aws_route53_zone.secondary[0].zone_id
  } : {}
}

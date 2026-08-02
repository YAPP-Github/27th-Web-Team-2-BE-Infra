resource "aws_route53_zone" "primary" {
  count = local.enable_custom_domain ? 1 : 0

  name = local.primary_zone_name

  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_zone" "secondary" {
  count = local.enable_custom_domain ? 1 : 0

  name = local.secondary_zone_name

  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_record" "alb_alias" {
  count = local.enable_custom_domain ? 1 : 0

  zone_id = aws_route53_zone.primary[0].zone_id
  name    = local.alb_primary_domain
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "alb_alias_secondary" {
  count = local.enable_custom_domain ? 1 : 0

  zone_id = aws_route53_zone.secondary[0].zone_id
  name    = local.alb_secondary_domain
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

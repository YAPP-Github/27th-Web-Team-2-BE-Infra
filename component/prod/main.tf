locals {
  enable_custom_domain = var.environment == "prod"
  route53_zone_name    = "moit.kr"
  alb_domain_name      = "api.moit.kr"
}

resource "aws_route53_zone" "primary" {
  count = local.enable_custom_domain ? 1 : 0

  name = local.route53_zone_name

  tags = {
    Environment = var.environment
  }
}

resource "aws_acm_certificate" "alb" {
  count = local.enable_custom_domain ? 1 : 0

  domain_name       = local.alb_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = local.enable_custom_domain ? {
    for dvo in aws_acm_certificate.alb[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  zone_id = aws_route53_zone.primary[0].zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "alb" {
  count = local.enable_custom_domain ? 1 : 0

  certificate_arn         = aws_acm_certificate.alb[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_lb_listener" "nomoney_https" {
  count = local.enable_custom_domain ? 1 : 0

  load_balancer_arn = var.alb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.alb[0].certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_record" "alb_alias" {
  count = local.enable_custom_domain ? 1 : 0

  zone_id = aws_route53_zone.primary[0].zone_id
  name    = local.alb_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

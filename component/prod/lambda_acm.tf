# Lambda 테스트 도메인 인증서를 발급하고 검증하는 리소스
resource "aws_acm_certificate" "lambda_api" {
  count = local.enable_lambda_api ? 1 : 0

  domain_name               = local.lambda_primary_domain
  subject_alternative_names = [local.lambda_secondary_domain]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "lambda_cert_validation" {
  for_each = local.enable_lambda_api ? {
    for dvo in aws_acm_certificate.lambda_api[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  zone_id = local.cert_validation_zone_by_domain[each.key]
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "lambda_api" {
  count = local.enable_lambda_api ? 1 : 0

  certificate_arn         = aws_acm_certificate.lambda_api[0].arn
  validation_record_fqdns = [for record in aws_route53_record.lambda_cert_validation : record.fqdn]
}

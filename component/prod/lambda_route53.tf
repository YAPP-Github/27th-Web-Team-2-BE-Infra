# Lambda 테스트 도메인을 API Gateway regional domain으로 연결하는 레코드
resource "aws_route53_record" "lambda_primary_alias" {
  count = local.enable_lambda_api ? 1 : 0

  zone_id = aws_route53_zone.primary[0].zone_id
  name    = local.lambda_primary_domain
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.lambda_primary[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.lambda_primary[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "lambda_secondary_alias" {
  count = local.enable_lambda_api ? 1 : 0

  zone_id = aws_route53_zone.secondary[0].zone_id
  name    = local.lambda_secondary_domain
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.lambda_secondary[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.lambda_secondary[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

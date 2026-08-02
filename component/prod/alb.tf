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

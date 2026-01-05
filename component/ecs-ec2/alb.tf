resource "aws_security_group" "nomoney_alb_sg" {
  name        = format("%s-nomoney-alb-sg", var.environment)
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb" "nomoney_alb" {
  name               = format("%s-nomoney-alb", var.environment)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nomoney_alb_sg.id]
  subnets = var.public_subnet_ids

  enable_deletion_protection = false
  enable_http2               = true

  tags = {
    Environment = var.environment
  }
}
resource "aws_lb_target_group" "nomoney_tg" {
  name        = format("%s-nomoney-tg", var.environment)
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/ping"
    protocol            = "HTTP"
    matcher             = "200"
  }

  deregistration_delay = 30

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "nomoney_http" {
  load_balancer_arn = aws_lb.nomoney_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.environment == "prod" ? "redirect" : "forward"

    # Redirect to HTTPS for Production
    dynamic "redirect" {
      for_each = var.environment == "prod" ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    # Forward to target group for non-Production
    target_group_arn = var.environment != "prod" ? aws_lb_target_group.nomoney_tg.arn : null
  }

  tags = {
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

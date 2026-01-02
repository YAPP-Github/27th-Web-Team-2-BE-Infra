resource "aws_security_group" "ecs_instance_sg" {
  name        = "${var.environment}-ecs-instance-sg"
  description = "Security group for ECS EC2 instances (shared runtime)"
  vpc_id      = var.vpc_id

  # Outbound: 기본 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SSH 인바운드 (필요한 경우에만 CIDR 넣기)
resource "aws_security_group_rule" "ssh_ingress" {
  for_each          = toset(var.ssh_ingress_cidrs)
  type              = "ingress"
  security_group_id = aws_security_group.ecs_instance_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [each.value]
}

# 앱 포트 인바운드 (ALB 전이라면 임시로 EC2 Public IP로 접근 테스트용)
resource "aws_security_group_rule" "app_ingress" {
  for_each          = toset(var.app_ingress_cidrs)
  type              = "ingress"
  security_group_id = aws_security_group.ecs_instance_sg.id
  from_port         = var.container_port
  to_port           = var.container_port
  protocol          = "tcp"
  cidr_blocks       = [each.value]
}
resource "aws_autoscaling_group" "ecs" {
  name                = "${var.environment}-ecs-asg"
  vpc_zone_identifier = var.public_subnet_ids

  min_size         = var.ecs_min_size
  max_size         = var.ecs_max_size
  desired_capacity = var.ecs_desired_capacity

  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-ecs-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}
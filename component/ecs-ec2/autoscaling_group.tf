resource "aws_autoscaling_group" "platform_ec2_asg" {
  name                = "${var.environment}-platform-ec2-asg"
  vpc_zone_identifier = var.public_subnet_ids

  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  health_check_type         = "EC2"
  health_check_grace_period = 240

  launch_template {
    id      = aws_launch_template.platform_ec2_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-platform-ec2-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}
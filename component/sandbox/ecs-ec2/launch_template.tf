# ECS Optimized AMI (Amazon Linux 2) 최신 ID
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs_lunch_template" {
  name_prefix   = "${var.environment}-ecs-launch-template"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ecs_instance_sg.id]

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tftpl", {
    cluster_name = aws_ecs_cluster.this.name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-ecs-instance"
      Environment = var.environment
    }
  }
}
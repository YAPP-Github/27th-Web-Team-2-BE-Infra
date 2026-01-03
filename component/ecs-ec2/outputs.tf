output "platform_ecs_cluster_name" {
  value = aws_ecs_cluster.platform_ecs_cluster.name
}

output "nomoney_api_service_name" {
  value = aws_ecs_service.nomoney_api.name
}

output "platform_ec2_asg_name" {
  value = aws_autoscaling_group.platform_ec2_asg.name
}
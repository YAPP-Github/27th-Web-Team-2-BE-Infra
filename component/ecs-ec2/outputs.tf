output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster_shared.name
}

output "schedule_vote_service_name" {
  value = aws_ecs_service.schedule_vote.name
}

output "cluster_ec2_shared_asg_name" {
  value = aws_autoscaling_group.cluster_ec2_shared_asg.name
}
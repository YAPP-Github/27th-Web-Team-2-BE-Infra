output "platform_ecs_cluster_name" {
  value = aws_ecs_cluster.platform_ecs_cluster.name
}

output "nomoney_api_service_name" {
  value = aws_ecs_service.nomoney_api.name
}

output "platform_ec2_asg_name" {
  value = aws_autoscaling_group.platform_ec2_asg.name
}

output "nomoney_alb_arn" {
  value = aws_lb.nomoney_alb.arn
}

output "nomoney_alb_dns_name" {
  value = aws_lb.nomoney_alb.dns_name
}

output "nomoney_alb_zone_id" {
  value = aws_lb.nomoney_alb.zone_id
}

output "nomoney_tg_arn" {
  value = aws_lb_target_group.nomoney_tg.arn
}

output "cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "listener_arn" {
  value = aws_lb_listener.lb_listener_443.arn
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.ec2_cp.name
}

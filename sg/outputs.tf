output "cluster_sg_id" {
  value = module.cluster_instance_sg.security_group_id
}

output "db_sg_id" {
  value = module.postgresql_sg.security_group_id
}

output "lb_sg_id" {
  value = module.load_balancer_sg.security_group_id
}


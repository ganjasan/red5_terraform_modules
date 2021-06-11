variable "vpc_id" {
  description = "VPC id for LB target group"
}

variable "service_name" {
  description = "service name used in service, target group, listener rule path condition and helath check"
}

variable "cluster_arn" {
  description = "ECS cluster ARN"
}

variable "desired_count" {
  description = "Service copy desired count"
}

variable "ecs_service_role_arn" {
  description = "ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf."
}

variable "task_definition_arn" {
  description = "Task definition ARN"
}

variable "container_name" {
  description = "Name of listener container in service"
}

variable "container_port" {
  description = "Listener container port"
}

variable "listener_arn" {
  description = "Listener ARN"
}

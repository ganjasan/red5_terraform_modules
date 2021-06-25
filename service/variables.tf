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

variable "listener_path_pattern" {
  description = "Pattern for listener redirection"
}

variable "health_path" {
  description = "Path to check health"
}

variable "capacity_provider_base" {
  default     = null
  description = "Number of tasks, at a minimum, to run on the specified capacity provider. Only one capacity provider in a capacity provider strategy can have a base defined."
}

variable "capacity_provider_name" {
  description = "Short name of the capacity provider."
}

variable "capacity_provider_weight" {
  description = "Relative percentage of the total number of launched tasks that should use the specified capacity provider"
}



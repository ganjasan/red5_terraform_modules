variable "region" {
  description = "AWS region"
  type        = string
}

variable "name" {
  description = "VPC name"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "app_name" {
  description = "Name of app project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

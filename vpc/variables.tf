variable "project_name" {
  description = "Project name to be used as a prefix in resource names "
}

variable "stage" {
  description = "Stage of infrustructure environment (Dev, Test, Prod, ...)"
}

variable "vpc_cidr" {
  default     = "172.16.0.0/16"
  description = "VPC cidr block"
}

variable "public_subnet_cidr_a" {
  default     = "172.16.1.0/24"
  description = "First public subnet cidr"

}

variable "public_subnet_cidr_b" {
  default     = "172.16.2.0/24"
  description = "Second public subnet cidr"
}

variable "private_subnet_cidr_a" {
  default     = "172.16.3.0/24"
  description = "First private subnet cidr"
}

variable "private_subnet_cidr_b" {
  default     = "172.16.4.0/24"
  description = "Second private subnet cidr"
}

variable "availability_zone_a" {
  default     = "eu-west-1a"
  description = "First AZ"
}

variable "availability_zone_b" {
  default     = "eu-west-1b"
  description = "Second AZ"
}


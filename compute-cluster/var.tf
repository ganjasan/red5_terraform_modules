variable "region" {
  description = "AWS region"
}

variable "backend_bucket" {
  description = "Backend bucket name"
}

variable "sg_bucket_key" {
  description = "Key for backend where SG initialized"
}

variable "vpc_bucket_key" {
  description = "Key for bucket where VPC state stored"
}

variable "iam_baucket_key" {
  description = "Key for bucket where IAM state stored"
}


variable "project_name" {
  description = "Project name to be used as a prefix in resource names "
}

variable "stage" {
  description = "Stage of infrustructure environment (Dev, Test, Prod, ...)"
}

variable "ami" {
  description = "AMI name for compute instances"
}

variable "instance_type" {
  description = "compute instance type"
}

variable "is_spot" {
  description = "Запросить инстанс по spot_price"
  type        = bool
}

variable "spot_price" {
  description = "price for spot instance"
}

variable "ssh_key_name" {
  description = "ssh key name to connect in compute instances"
}

variable "certificate_arn" {
  description = "SSL/TLS certificate arn"
}


variable "asg_desired_capacity" {
  description = "ASG desired capacity"
}

variable "asg_min_size" {
  description = "ASG min capacity"
}

variable "asg_max_size" {
  description = "ASG max capacity"
}

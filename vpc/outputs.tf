output "vpc_id" {
  value = module.this.vpc_id
}

output "vpc_arn" {
  value = module.this.vpc_arn
}

output "vpc_cidr_block" {
  value = module.this.vpc_cidr_block
}

output "vpc_ipv6_cidr_block" {
  value = module.this.vpc_ipv6_cidr_block
}

output "public_subnets" {
  value = module.this.public_subnets
}

output "private_subnets" {
  value = module.this.private_subnets
}

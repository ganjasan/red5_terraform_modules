module "load_balancer_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "load_balancer"
  description = "Load Balancer security group. Open for all on HTTP, HTTPS"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = ["https-443-tcp", "http-80-tcp"]
}

module "cluster_instance_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ecs_instance"
  description = "Security group for cluster instances. Open for Load Balancer on HTTP"
  vpc_id      = var.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.load_balancer_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

module "postgresql_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "postgresql"
  description = "Security group for PostgreSQL RDS. Open on 5432 only from cluster instances"
  vpc_id      = var.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.cluster_instance_sg.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

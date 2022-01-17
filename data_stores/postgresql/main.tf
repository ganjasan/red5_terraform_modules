data "aws_db_snapshot" "db_snapshot" {
  db_instance_identifier = var.snapshot_db_instance_identifier
  most_recent            = true
  include_shared         = true
}

resource "aws_security_group_rule" "open_port_in_vpc" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.to_port
  security_group_id = var.security_group_id
  cidr              = var.vpc_cidr
  description       = "Allow traffic in db port for all instance in VPC"
}

module "red5_db" {
  snapshot_identifier = try(data.aws_db_snapshot.db_snapshot.id, null)

  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "${var.db_name}-${var.environment}"

  engine               = "postgres"
  engine_version       = var.engine_version
  family               = var.db_family
  major_engine_version = var.major_engine_version

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted

  name     = var.db_name
  username = jsondecode(data.aws_secretsmanager_secret_version.db_secrets.secret_string)["user_name"]
  password = jsondecode(data.aws_secretsmanager_secret_version.db_secrets.secret_string)["password"]
  port     = var.port

  multi_az               = var.multi_az
  subnet_ids             = var.subnets_ids
  vpc_security_group_ids = [var.security_group_id]

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
}

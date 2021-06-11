locals {
  create_cidr_rule = length(var.allowed_cidrs) > 0 ? true : false
  create_sg_rule   = length(var.allowed_security_groups) > 0 ? true : false
}


resource "aws_security_group_rule" "allow_sgs_to_efs" {
  count = local.create_sg_rule ? length(var.allowed_security_groups) : 0

  description              = "SG ${var.allowed_security_groups[count.index]} permitted access to EFS mounts"
  from_port                = 2049
  protocol                 = "tcp"
  security_group_id        = var.security_group_id
  source_security_group_id = var.allowed_security_groups[count.index]
  to_port                  = 2049
  type                     = "ingress"
}

resource "aws_security_group_rule" "allow_cidrs_to_efs" {
  count = local.create_cidr_rule ? 1 : 0

  cidr_blocks       = var.allowed_cidrs
  description       = "CIDRs permitted access to EFS mounts"
  from_port         = 2049
  protocol          = "tcp"
  security_group_id = var.security_group_id
  to_port           = 2049
  type              = "ingress"
}

resource "aws_security_group_rule" "all_for_efs_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = var.security_group_id
}

resource "aws_efs_file_system" "this" {
  creation_token = var.name

  encrypted                       = true
  kms_key_id                      = var.efs_kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.throughput_mode == "provisioned" ? var.provisioned_throughput : null
  tags                            = var.additional_tags
  throughput_mode                 = var.throughput_mode
}

resource "aws_efs_mount_target" "this" {
  for_each = toset(var.subnets)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.security_group_id]
}

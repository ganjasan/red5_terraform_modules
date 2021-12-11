module "this" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = "${var.cidr_16}.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["${var.cidr_16}.1.0/24", "${var.cidr_16}.2.0/24"]
  public_subnets  = ["${var.cidr_16}.101.0/24", "${var.cidr_16}.102.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true",
    App         = "${var.app_name}",
    Environment = "${var.environment}",
  }
}

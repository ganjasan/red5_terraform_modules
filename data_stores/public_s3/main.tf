terraform {
  required_version = ">= 1.0.0, <2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.name

  acl = "public-read"

  tags = {
    Name  = var.name
    App   = var.app_name
  }

  versioning {
    enabled = true
  }
}


data "terraform_remote_state" "sg" {
  backend = "s3"

  config = {
    bucket = var.backend_bucket
    key    = var.sg_bucket_key
    region = var.region
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.backend_bucket
    key    = var.vpc_bucket_key
    region = var.region
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = var.backend_bucket
    key    = var.iam_baucket_key
    region = var.region
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    ecs_cluster_name = "${var.project_name}_cluster_${var.stage}"
  }
}

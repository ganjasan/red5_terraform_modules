#SG rules
resource "aws_security_group_rule" "LB_in_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.terraform_remote_state.sg.outputs.lb_sg_id
}

resource "aws_security_group_rule" "LB_in_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.terraform_remote_state.sg.outputs.lb_sg_id
}

resource "aws_security_group_rule" "LB_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.terraform_remote_state.sg.outputs.lb_sg_id
}

resource "aws_security_group_rule" "instance_in" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 65535
  protocol                 = "TCP"
  security_group_id        = data.terraform_remote_state.sg.outputs.instance_sg_id
  source_security_group_id = data.terraform_remote_state.sg.outputs.lb_sg_id
  description              = "reserved 32768-65538 port for microservices available from LB"
}

resource "aws_security_group_rule" "instance_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.terraform_remote_state.sg.outputs.instance_sg_id
}

#lounch config
resource "aws_launch_configuration" "launch_conf_spot" {
  count = var.is_spot ? 1 : 0

  name_prefix          = var.project_name
  image_id             = var.ami
  instance_type        = var.instance_type
  spot_price           = var.spot_price
  security_groups      = [data.terraform_remote_state.sg.outputs.instance_sg_id]
  iam_instance_profile = data.terraform_remote_state.iam.outputs.ecs_service_role_profile_name
  key_name             = var.ssh_key_name
  user_data            = data.template_file.user_data.rendered


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "launch_conf_on_demand" {
  count = var.is_spot ? 0 : 1

  name_prefix          = var.project_name
  image_id             = var.ami
  instance_type        = var.instance_type
  security_groups      = [data.terraform_remote_state.sg.outputs.instance_sg_id]
  iam_instance_profile = data.terraform_remote_state.iam.outputs.ecs_service_role_profile_name
  key_name             = var.ssh_key_name
  user_data            = data.template_file.user_data.rendered


  lifecycle {
    create_before_destroy = true
  }
}

#ASG
resource "aws_autoscaling_group" "asg" {
  name_prefix = var.project_name
  min_size    = var.asg_min_size
  max_size    = var.asg_max_size
  vpc_zone_identifier = [
    data.terraform_remote_state.vpc.outputs.public_subnet_a_id,
    data.terraform_remote_state.vpc.outputs.public_subnet_b_id
  ]
  capacity_rebalance    = true
  launch_configuration  = var.is_spot ? aws_launch_configuration.launch_conf_spot[0].name : aws_launch_configuration.launch_conf_on_demand[0].name
  health_check_type     = "ELB"
  desired_capacity      = var.asg_desired_capacity
  protect_from_scale_in = true


  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}_compute_instance"
    propagate_at_launch = true
  }
}

#ALB
resource "aws_lb" "lb" {
  name_prefix        = var.project_name
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.sg.outputs.lb_sg_id]
  subnets = [
    data.terraform_remote_state.vpc.outputs.public_subnet_a_id,
    data.terraform_remote_state.vpc.outputs.public_subnet_b_id
  ]
  internal = false
}

resource "aws_lb_listener" "lb_listener_80" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "lb_listener_443" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}

#Capacity provider
resource "aws_ecs_capacity_provider" "ec2_cp" {
  name = "${var.project_name}_ec2_cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

#ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name               = "${var.project_name}_cluster"
  capacity_providers = [aws_ecs_capacity_provider.ec2_cp.name]
}


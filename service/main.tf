resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = var.cluster_arn
  desired_count   = var.desired_count
  iam_role        = var.ecs_service_role_arn
  launch_type     = "EC2"
  task_definition = var.task_definition_arn

  load_balancer {
    target_group_arn = aws_lb_target_group.service_tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}

resource "aws_lb_target_group" "service_tg" {
  name     = var.service_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/${var.service_name}"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener_rule" "service_lb_rule" {
  listener_arn = var.listener_arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.arn
  }

  condition {
    path_pattern {
      values = ["/${var.service_name}/*"]
    }
  }
}




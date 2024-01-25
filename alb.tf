resource "aws_security_group" "gatus_alb" {
  count       = var.alb == null ? 1 : 0
  name        = format("%s-%s", local.name, "gatus-alb")
  description = "Security group for the Gatus Application Load Balancer"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "gatus_alb_ingress" {
  description       = "Traffic allowed to access status page via ALB"
  type              = "ingress"
  from_port         = var.alb_listener_config.port
  to_port           = var.alb_listener_config.port
  protocol          = "tcp"
  security_group_id = aws_security_group.gatus_alb[0].id
  cidr_blocks       = var.alb_listener_config.allowed_cidr_blocks
}

resource "aws_security_group_rule" "gatus_alb_egress" {
  description              = "ALB to Gatus container traffic"
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.gatus_alb[0].id
  source_security_group_id = aws_security_group.gatus.id
}

resource "aws_lb" "alb" {
  count                            = var.alb == null ? 1 : 0
  name                             = format("%s-%s", substr(local.name, 0, 26), "gatus")
  internal                         = !var.public
  load_balancer_type               = "application"
  subnets                          = var.subnets
  enable_cross_zone_load_balancing = true
  security_groups                  = [var.alb == null ? aws_security_group.gatus_alb[0].id : var.alb.security_group_id]
  drop_invalid_header_fields       = true

  tags = {
    Name = format("%s-%s", local.name, "gatus")
  }
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = var.alb == null ? aws_lb.alb[0].arn : var.alb.arn
  port              = var.alb_listener_config.port
  protocol          = var.alb_listener_config.protocol
  ssl_policy        = var.alb_listener_config.protocol == "HTTPS" ? "ELBSecurityPolicy-FS-1-2-Res-2020-10" : ""
  certificate_arn   = var.alb_listener_config.protocol == "HTTPS" ? var.alb_listener_config.certificate_arn : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}

resource "aws_lb_target_group" "alb" {
  name_prefix = "gatus"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 10 # TODO: tune
    interval            = 60
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = format("%s-%s", local.name, "gatus")
  }
}

resource "aws_alb_listener_rule" "alb" {
  listener_arn = aws_lb_listener.alb.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }

  condition {
    path_pattern {
      values = [var.alb_listener_config.path]
    }
  }
}

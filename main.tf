locals {
  env_vars = merge(
    {
      GATUS_CONFIG_PATH = var.config_path
    },
    var.env_vars,
    var.database != null ? (
    {
      DB_HOST = var.database.host
      DB_PORT = var.database.port
      DB_NAME = var.database.name
    }
    ) : {},
  )
  secrets = merge(
    var.secrets,
    var.database != null ? (
    {
      DB_USER = var.database.user_arn
      DB_PASSWORD = var.database.password_arn
    }
    ) : {},
  )
}

resource "aws_ecs_task_definition" "gatus" {
  family                   = local.name
  network_mode             = "awsvpc"
  requires_compatibilities = [var.use_fargate ? "FARGATE" : "EC2"]
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.gatus.arn
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    merge(
      {
        name = "${local.name}-gatus"
        image = var.image
        cpu = var.cpu
        memory = var.memory
        networkMode = "awsvpc"
        portMappings = [
          {
            "containerPort" = 8080
            "hostPort" = 8080
            protocol = "tcp"
          }
        ]
        environment = [
          for key, value in local.env_vars :
          {
            name = key
            value = value
          }
        ]
        secrets = [
          for key, value in local.secrets :
          {
            name = key
            valueFrom = value
          }
        ]
        placementStrategy = [
          {
            field = "attribute:ecs.availability-zone",
            type = "spread"
          }
        ]
      },
      var.log_group != null ? {
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group = var.log_group.arn
            awslogs-region = var.log_group.region
            awslogs-stream-prefix = "${local.name}-gatus"
          }
        }
      } : {}
    )
  ])
}

resource "aws_security_group" "gatus" {
  name        = format("%s-%s", local.name, "gatus")
  description = "Security group for the Gatus"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "gatus_ingress_from_alb" {
  description              = "ALB to Gatus container traffic"
  type                     = "ingress"
  from_port                = var.alb_listener_config.port
  to_port                  = var.alb_listener_config.port
  protocol                 = "all"
  security_group_id        = aws_security_group.gatus.id
  source_security_group_id = var.alb == null ? aws_security_group.gatus_alb[0].id : var.alb.security_group_id
}

resource "aws_ecs_service" "gatus" {
  name                   = local.name
  cluster                = var.ecs_cluster.arn
  enable_execute_command = var.enable_execute_command
  task_definition        = aws_ecs_task_definition.gatus.arn
  platform_version       = var.platform_version
  desired_count          = var.size.desired
  launch_type            = var.use_fargate ? "FARGATE" : "EC2"
  propagate_tags         = "TASK_DEFINITION"

  network_configuration {
    security_groups  = concat([aws_security_group.gatus.id], var.security_groups)
    subnets          = var.subnets
    assign_public_ip = var.public
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb.arn
    container_name   = "${local.name}-gatus"
    container_port   = 8080
  }


  lifecycle {
    #    ignore_changes = [desired_count]
  }
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    sid     = "EcsAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "gatus" {
  name               = "${local.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

module "example" {
  source = "../../"

  env = var.env
  ecs_cluster = {
    arn  = aws_ecs_cluster.default.arn
    name = aws_ecs_cluster.default.name
  }
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  subnets            = data.aws_subnets.default.ids
  vpc_id             = data.aws_vpc.default.id
  public             = true

  alb_listener_config = {
    port                = 80
    health_check_port   = 80
    protocol            = "HTTP"
    allowed_cidr_blocks = ["0.0.0.0/0"]
    certificate_arn     = ""
    path                = "/"
  }
}

resource "aws_ecs_cluster" "default" {
  name = "${var.env}-gatus-default"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution.name
}

resource "aws_security_group_rule" "gatus_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  security_group_id = module.example.security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
}

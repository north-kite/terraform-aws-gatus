locals {
  name = format("%s-%s", var.service_name, var.env)

  #  target_groups = { for k, v in var.alb_listener_config : "alb_${k}" => { arn = aws_lb_target_group.alb[k].arn, port = v.port } }

  # TODO: add support for DB, currently using memory
  #  db_info = {
  #    endpoint      = var.postgres_host
  #    database_name = var.gatus_database_config.name
  #  }

}

data "aws_subnet" "gatus" {
  for_each = var.subnets
  id       = each.value
}

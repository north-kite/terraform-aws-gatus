locals {
  name = format("%s-%s", var.service_name, var.env)
}

data "aws_subnet" "gatus" {
  for_each = var.subnets
  id       = each.value
}

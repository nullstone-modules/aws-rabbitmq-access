resource "aws_security_group_rule" "app-to-datastore" {
  for_each = { for port in local.db_ports : port => port }

  description              = "Allow access from app to RabbitMQ"
  security_group_id        = var.app_metadata["security_group_id"]
  type                     = "egress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
  source_security_group_id = local.db_security_group_id
}

resource "aws_security_group_rule" "datastore-from-app" {
  for_each = { for port in local.db_ports : port => port }

  description              = "Allow access to RabbitMQ from app"
  security_group_id        = local.db_security_group_id
  type                     = "ingress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
  source_security_group_id = var.app_metadata["security_group_id"]
}

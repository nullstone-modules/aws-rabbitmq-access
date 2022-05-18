terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

locals {
  tags          = data.ns_workspace.this.tags
  block_name    = data.ns_workspace.this.block_name
}

data "ns_connection" "rabbitmq" {
  name = "rabbitmq"
  type = "rabbitmq/aws"
}

locals {
  db_admin_secret_id   = data.ns_connection.rabbitmq.outputs.db_admin_secret_id
  db_protocol          = data.ns_connection.rabbitmq.outputs.db_protocol
  db_endpoints         = data.ns_connection.rabbitmq.outputs.db_endpoints
  db_ports             = distinct([for url in local.db_endpoints : split(":", url)[1]])
  db_security_group_id = data.ns_connection.rabbitmq.outputs.db_security_group_id
}

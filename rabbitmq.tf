data "ns_connection" "rabbitmq" {
  name     = "rabbitmq"
  type     = "rabbitmq/aws"
  contract = "datastore/aws/rabbitmq:*"
}

locals {
  db_admin_secret_id   = data.ns_connection.rabbitmq.outputs.db_admin_secret_id
  db_protocol          = data.ns_connection.rabbitmq.outputs.db_protocol
  db_endpoints         = data.ns_connection.rabbitmq.outputs.db_endpoints
  db_ports             = distinct([for url in local.db_endpoints : split(":", url)[1]])
  db_security_group_id = data.ns_connection.rabbitmq.outputs.db_security_group_id
}

data "ns_connection" "rabbitmq" {
  name     = "rabbitmq"
  contract = "datastore/aws/rabbitmq:*"
}

locals {
  // uri_matcher provides a way to separate scheme from authority in a URL
  uri_matcher = "^(?:(?P<scheme>[^:/?#]+):)?(?://(?P<authority>[^/?#]*))?"
}

locals {
  db_admin_secret_id  = data.ns_connection.rabbitmq.outputs.db_admin_secret_id
  db_protocol         = data.ns_connection.rabbitmq.outputs.db_protocol
  db_endpoints        = data.ns_connection.rabbitmq.outputs.db_endpoints
  db_console_urls     = data.ns_connection.rabbitmq.outputs.db_console_urls
  db_console_url_objs = [for url in local.db_console_urls : regex(local.uri_matcher, url)]
  // Convert console urls to endpoints https://subdomain[:port] => subdomain:port
  db_console_endpoints = [for obj in local.db_console_url_objs : "${lookup(obj, "authority", "")}${length(split(":", lookup(obj, "authority", ""))) > 1 ? "" : (lookup(obj, "scheme", "") == "https" ? ":443" : ":80")}"]
  db_ports             = distinct([for url in concat(local.db_endpoints, local.db_console_endpoints) : split(":", url)[1]])
  db_security_group_id = data.ns_connection.rabbitmq.outputs.db_security_group_id
}

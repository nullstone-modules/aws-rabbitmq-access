locals {
  admin             = try(data.aws_secretsmanager_secret_version.admin.secret_string, "")
  admin_username    = try(lookup(local.admin, "username"), "")
  admin_password    = try(lookup(local.admin, "password"), "")
  user_pass_encoded = local.admin == "" ? "" : "${urlencode(local.admin_username)}:${urlencode(local.admin_password)}@"

  urls = [for endpoint in local.db_endpoints : "${local.db_protocol}://${local.user_pass_encoded}${endpoint}"]
}

output "secrets" {
  value = [
    {
      name  = "RABBITMQ_URL"
      value = join(",", local.urls)
    }
  ]
}

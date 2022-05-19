data "aws_secretsmanager_secret_version" "admin" {
  secret_id = local.db_admin_secret_id
}

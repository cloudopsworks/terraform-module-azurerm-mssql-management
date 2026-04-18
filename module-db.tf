##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  base_users = {
    for k, v in var.users : k => merge(v, {
      name = try(v.username, k)
    })
  }
}

module "db" {
  source    = "git::https://github.com/cloudopsworks/terraform-module-mssql-management.git?ref=v1.0.0"
  providers = { mssql = mssql }

  org        = var.org
  is_hub     = var.is_hub
  spoke_def  = var.spoke_def
  extra_tags = var.extra_tags

  users                    = local.base_users
  databases                = var.databases
  server_host              = local.mssql_conn.host
  server_port              = local.mssql_conn.port
  password_rotation_period = var.password_rotation_period
  force_reset              = var.force_reset
}

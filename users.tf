##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "random_password" "user" {
  for_each         = { for k, v in var.users : k => v if !try(v.create_login, true) }
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    rotation = var.password_rotation_period
    reset    = var.force_reset
  }
}

resource "mssql_login" "user" {
  for_each = { for k, v in var.users : k => v if !try(v.create_login, true) }
  server {
    host = local.mssql_conn.host
    port = local.mssql_conn.port
    login {
      username = local.mssql_conn.username
      password = local.mssql_conn.password
    }
  }
  login_name = try(each.value.username, each.key)
  password   = random_password.user[each.key].result
}

resource "mssql_user" "user" {
  for_each = {
    for item in flatten([
      for k, v in var.users : [
        for db in try(v.databases, []) : {
          key       = "${k}-${db}"
          login_key = k
          username  = try(v.username, k)
          database  = db
          roles     = try(v.roles, ["db_datareader"])
        }
      ] if !try(v.create_login, true)
    ]) : item.key => item
  }
  server {
    host = local.mssql_conn.host
    port = local.mssql_conn.port
    login {
      username = local.mssql_conn.username
      password = local.mssql_conn.password
    }
  }
  username   = each.value.username
  login_name = mssql_login.user[each.value.login_key].login_name
  database   = each.value.database
  roles      = each.value.roles

  depends_on = [mssql_login.user]
}

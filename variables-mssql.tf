##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## YAML Input Format
# users:
#   owner:                           # (Required) Key is the logical user name
#     username: "appowner"           # (Required) SQL Server login name
#     databases: ["mydb"]            # (Required) List of databases for this user
#     roles: ["db_owner"]            # (Optional) Database roles to assign. Default: ["db_owner"]
#     create_login: true             # (Optional) Create a SQL Server login. Default: true.
variable "users" {
  description = "Map of SQL Server logins/users to create with their database assignments."
  type        = any
  default     = {}
}

## YAML Input Format
# databases:
#   mydb:                            # (Required) Key is the logical database name
#     name: "mydb"                   # (Required) Actual database name
variable "databases" {
  description = "Map of SQL Server databases managed by this module (for reference; databases are created in the provisioning module)."
  type        = any
  default     = {}
}

## YAML Input Format
# hoop:
#   enabled: false                   # (Optional) Enable Hoop connection output. Default: false.
#   community: true                  # (Optional) true=null output; false=enterprise. Default: true.
#   agent_id: ""                     # (Required when enabled+enterprise) Hoop agent UUID.
#   port: 1434                       # (Optional) Local port for Hoop tunnel mode. Default: 1434.
#   db_name: "master"                # (Optional) Database for hoop tunnel connection.
#   server_name: ""                  # (Optional) Server name for hoop tunnel mode.
#   import: false                    # (Optional) Import existing connection. Default: false.
#   tags: {}                         # (Optional) Tags for Hoop connections.
#   access_control: []               # (Optional) Access control groups.
variable "hoop" {
  description = "Hoop connection configuration. Enterprise mode stores per-field secrets in Key Vault."
  type        = any
  default     = {}
}

## YAML Input Format
# azure:
#   enabled: false                   # (Optional) Connect via Azure MSSQL Server. Default: false.
#   from_secret: false               # (Optional) Read credentials from Key Vault secret. Default: false.
#   secret_name: ""                  # (Required when from_secret=true) KV secret name containing JSON credentials.
#   server_name: ""                  # (Required when enabled+!from_secret) MSSQL Server name (short name without .database.windows.net).
#   resource_group_name: ""          # (Optional) Resource group of the server.
#   admin_username: "adminuser"      # (Optional) Admin username. Default: "adminuser".
#   admin_password: ""               # (Optional) Admin password.
#   db_name: "master"                # (Optional) Default database. Default: "master".
variable "azure" {
  description = "Azure MSSQL Server connection settings. Mutually exclusive with direct/hoop."
  type        = any
  default     = {}
}

## YAML Input Format
# direct:
#   host: ""                         # (Required) MSSQL server FQDN or IP.
#   port: 1433                       # (Optional) Port. Default: 1433.
#   username: ""                     # (Required) Admin username.
#   password: ""                     # (Required) Admin password.
#   db_name: "master"                # (Optional) Default database. Default: "master".
#   server_name: ""                  # (Optional) Logical server name.
variable "direct" {
  description = "Direct MSSQL connection settings. Used when azure.enabled=false and hoop.enabled=false."
  type        = any
  default     = {}
}

## YAML Input Format
# password_rotation_period: "30d"
variable "password_rotation_period" {
  description = "(Optional) Password rotation period for user credentials. Default: empty."
  type        = string
  default     = ""
}

## YAML Input Format
# force_reset: false
variable "force_reset" {
  description = "(Optional) Force password reset for all managed users on next apply. Default: false."
  type        = bool
  default     = false
}

## YAML Input Format
# key_vault_name: "my-keyvault"
variable "key_vault_name" {
  description = "(Required) Name of the existing Azure Key Vault for credential and hoop secret storage."
  type        = string
}

## YAML Input Format
# key_vault_resource_group_name: "rg-shared"
variable "key_vault_resource_group_name" {
  description = "(Required) Resource group name of the existing Azure Key Vault."
  type        = string
}

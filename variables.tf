#---------------------------------------------------------------
# Variables for managed resources
#---------------------------------------------------------------

variable "location" {
  type = string
}

variable "tags" {
  type = map
}

variable "key_vault" {
  type = object({
    name                      = string
    resource_group_name       = string
    purge_protection_enabled  = bool
    secrets_owners            = string
  })
}

variable "key_vault_secrets" {
  type = list(object({
    secret_name     = string
    secret_value    = string
  }))
}
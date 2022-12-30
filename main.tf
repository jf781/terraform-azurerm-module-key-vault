# Create Key Vault
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault.name
  location                    = var.location
  resource_group_name         = var.key_vault.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = var.key_vault.purge_protection_enabled
  sku_name                    = "standard"
  tags                        = var.tags 


  # Access for Terraform Cloud service principal
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set",]
  }

  # Access for key vault owners group
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.key_vault.secrets_owners

    secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set",]
  }
}

# Create Key Vault Secret(s)
resource "azurerm_key_vault_secret" "examples" {
  for_each   = {for i, v in var.key_vault_secrets: i => v}
  name       = each.value.secret_name
  value = each.value.secret_value
  key_vault_id = azurerm_key_vault.key_vault.id
}
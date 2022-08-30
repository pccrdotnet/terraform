terraform{
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "=3.0.0"
        }
    }
}

provider "azurerm" {
  features {}

}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
    name      = var.rgname
    location  = var.location
    tags = {
      "env" = "security"
    }
}

resource "azurerm_key_vault" "keyvaultapp" {
    name                        = var.kvname
    location                    = azurerm_resource_group.rg.location
    resource_group_name         = azurerm_resource_group.rg.name
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days  = 7
    purge_protection_enabled    = true
    enabled_for_disk_encryption = true
    enable_rbac_authorization   = true
    enabled_for_deployment      = true 

    sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "current_user" {
    key_vault_id = azurerm_key_vault.keyvaultapp.id
    tenant_id    = data.azurerm_client_config.current.tenant_id
    object_id    = data.azurerm_client_config.current.object_id //User or SP Id
    
    secret_permissions  = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set", ]
    key_permissions     = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", ]
    storage_permissions = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update", ]
}
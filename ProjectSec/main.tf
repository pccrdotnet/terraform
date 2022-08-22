terraform{
    azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
    }
}

resource "azurerm_resource_group" "rg" {
    name = var.rgname
    location = var.location
    tags = {
      "env" = "security"
    }
}

resource "azurerm_key_vault" "kv" {
    name = var.kvname
    location = var.location
    sku_name = ""
}
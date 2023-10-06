terraform {
  required_providers {
    azurerm = {
      version = "~>3.74.0"
      source  = "hashicorp/azurerm"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Deploy a storage account
# ------------------------------------------------------------------------------------------------------

# Generate random ID to avoid naming clashes for storage account
resource "random_id" "storage_account_id" {
  byte_length = 8
}

# Deploy storage account
resource "azurerm_storage_account" "storage_account" {
  name                     = "sta${lower(random_id.storage_account_id.hex)}"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = var.tags
}

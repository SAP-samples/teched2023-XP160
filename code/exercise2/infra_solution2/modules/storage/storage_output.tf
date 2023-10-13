output "STORAGE_ACCOUNT_NAME" {
  value = azurerm_storage_account.storage_account.name
}

output "STORAGE_ACCOUNT_ACCESS_KEY" {
  value = azurerm_storage_account.storage_account.primary_access_key
}

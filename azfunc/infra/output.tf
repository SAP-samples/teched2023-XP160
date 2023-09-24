output "APPLICATIONINSIGHTS_CONNECTION_STRING" {
  value     = module.applicationinsights.APPLICATIONINSIGHTS_CONNECTION_STRING
  sensitive = true
}

/*
output "AZURE_KEY_VAULT_ENDPOINT" {
  value     = module.keyvault.AZURE_KEY_VAULT_ENDPOINT
  sensitive = true
}
*/

output "AZURE_LOCATION" {
  value = var.location
}

output "AZFUNC_TRACKING_API_URL" {
  value = "https://${azurerm_linux_function_app.tracking_function_app.default_hostname}"
}

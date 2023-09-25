output "AZURE_LOCATION" {
  value = var.location
}

output "RESOURCE_GROUP_NAME" {
  value = azurerm_resource_group.rg.name
}

output "APPLICATIONINSIGHTS_CONNECTION_STRING" {
  value     = module.applicationinsights.APPLICATIONINSIGHTS_CONNECTION_STRING
  sensitive = true
}

output "AZFUNC_TRACKING_API_URL" {
  value = module.azurefunction.FUNCTION_APP_URL
}

output "FUNCTION_NAME" {
  value = module.azurefunction.FUNCTION_NAME
}

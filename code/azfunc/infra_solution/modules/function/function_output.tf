output "FUNCTION_NAME" {
  value = azurerm_linux_function_app.function_app.name
}

output "FUNCTION_APP_URL" {
  value = "https://${azurerm_linux_function_app.function_app.default_hostname}"
}

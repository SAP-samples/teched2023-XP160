output "FUNCTION_URL" {
  value = "${var.function_app_url}api/${var.function_name}?code=${data.azurerm_function_app_host_keys.func_keys.default_function_key}"
  description = "Function URL with default keys"
  sensitive = true
}

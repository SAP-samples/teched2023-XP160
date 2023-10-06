data "azurerm_function_app_host_keys" "func_keys" {
  name                = var.function_name
  resource_group_name = var.resource_group_name
}

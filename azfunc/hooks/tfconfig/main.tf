variable "function_app_name" {
  description = "The name of the function app"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

data "azurerm_function_app_host_keys" "host_keys" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
}

output "DEFAULT_KEY"{
    value = data.azurerm_function_app_host_keys.host_keys.default_key
    sensitive = true
}


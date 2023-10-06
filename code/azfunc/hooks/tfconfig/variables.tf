variable "resource_group_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "function_name" {
  description = "The name of the function app"
  type        = string
}

variable "function_app_url" {
  description = "the url of the function app"
  type        = string
}

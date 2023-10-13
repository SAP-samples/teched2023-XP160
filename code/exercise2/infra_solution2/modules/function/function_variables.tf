variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "storage_account_access_key" {
  description = "The value of the storage account access key"
  type        = string
}

variable "application_insights_connection_string" {
    description = "The connection string for the application insights instance"
    type        = string 
}

variable "service_plan_id" {
  description = "The ID of the service plan within which the function app exists"
  type        = string
}

variable "function_name" {
  description = "The name of the function app"
  type        = string
}

variable "azd_service_name" {
  description = "The azd service name"
  type        = string
  default     = "azfunc-tracking-status"
}

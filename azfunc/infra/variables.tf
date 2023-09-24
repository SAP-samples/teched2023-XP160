variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
}

variable "principal_id" {
  description = "The Id of the azd service principal to add to deployed keyvault access policies"
  type        = string
  default     = ""
}

variable "storage_account_tier" {
  description = "Tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Replication type of the storage account"
  type        = string
  default     = "LRS"
}

// App specific parameters - provide the values via the main.parameters.json referencing e.g. environment parameters
variable "sku_name" {
  description = "The name of the SKU for the app plan"
  type        = string
  default     = "Y1"
}

variable "use_mock_response" {
  description = "Parameter if Mock response should be used"
  type        = bool
  default     = true
}

variable "tracking_api_endpoint" {
  description = "HTTP endpoint of the tracking API"
  type        = string
  default     = "https://api-test.dhl.com/track/shipments"
}

variable "tracking_api_key" {
  description = "API key of tracking API"
  type        = string
  default     = "abcdefg12345"
  sensitive   = true
}

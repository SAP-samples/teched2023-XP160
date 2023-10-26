variable "cf_org_id" {
  type        = string
  description = "The ID of the Cloud Foundry org."
}

variable "cf_org_name" {
  type        = string
  description = "The name of the CF org."
}

variable "region" {
  type        = string
  description = "Username for Cloud Foundry"
}

variable "name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}
variable "cf_space_managers" {
  type        = list(string)
  description = "The list of Cloud Foundry space managers."
  default     = []
}

variable "cf_space_developers" {
  type        = list(string)
  description = "The list of Cloud Foundry space developers."
  default     = []
}

variable "cf_space_auditors" {
  type        = list(string)
  description = "The list of Cloud Foundry space auditors."
  default     = []
}

variable "cf_username" {
  type        = string
  description = "Username for Cloud Foundry to use CF CLI for space user creation"
  sensitive   = true
}

variable "cf_password" {
  type        = string
  description = "Password for Cloud Foundry to use CF CLI for space user creation"
  sensitive   = true
}

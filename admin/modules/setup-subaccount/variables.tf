variable "user_number" {
  type        = string
  description = "The user number for the TechEd session XP160"
}

variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us20"
}

variable "admins" {
  type = list(string)
  description = "The list of users with respective admin rights"
}

variable "cf_users" {
  type = list(string)
  description = "The list of users for Cloudfoundry"
}

variable "azure_subscription_id" {
  type = string
  description = "The list of users with respective rights"
}
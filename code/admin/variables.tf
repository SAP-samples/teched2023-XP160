variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "ap21"
}

variable "subaccount_users" {
  type        = list(string)
  description = "The list of users with respective rights"
}

variable "cf_users" {
  type        = list(string)
  description = "The list of users with respective rights"
}

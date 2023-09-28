variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us20"
}

variable "subaccount_users" {
  type        = list(string)
  description = "The list of users with respective rights"
}

variable "cf_users" {
  type        = list(string)
  description = "The list of users with respective rights"
}

variable "s4_resource_id" {
  type        = string
  description = "The resource ID of the S/4HANA loadbalancer on Azure"
  default     = "/subscriptions/XXXXXXXXXXXXXXXXX/resourceGroups/ZZZZZZZZ/providers/Microsoft.Network/privateLinkServices/YYYYYYYYY"
}

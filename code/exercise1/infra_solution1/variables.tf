variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount id of the subaccount."
}

variable "cf_org_id" {
  type        = string
  description = "The Cloudfoundry org id in the subaccount."
}

variable "cf_org_name" {
  type        = string
  description = "The name of the Cloudfoundry organization"
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "ap21"
}

variable "s4_resource_id" {
  type        = string
  description = "The resource ID of the S/4HANA loadbalancer on Azure"
  default     = "/subscriptions/XXXXXXXXXXXXXXXXX/resourceGroups/ZZZZZZZZ/providers/Microsoft.Network/privateLinkServices/YYYYYYYYY"
}

variable "username" {
  type        = string
  description = "The user that should be assigned all necessary roles."
}

variable "s4_connection_pw" {
  type        = string
  description = "Password for the destination to the S/4HANA system on Azure"
  sensitive   = true
}

variable "cf_password" {
  type        = string
  description = "Password for Cloud Foundry"
  sensitive   = true
}

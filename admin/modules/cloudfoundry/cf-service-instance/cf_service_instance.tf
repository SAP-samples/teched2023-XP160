###
# Required provider
###
terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~>0.51.3"
    }
  }
}

###
# Fecth  service plan name
###
data "cloudfoundry_service" "service" {
  name = var.service_name
}

###
# Create a CF service instance
###
resource "cloudfoundry_service_instance" "service" {
  name         = var.service_name
  space        = var.cf_space_id
  service_plan = data.cloudfoundry_service.service.service_plans["${var.plan_name}"]
  json_params  = var.parameters
}

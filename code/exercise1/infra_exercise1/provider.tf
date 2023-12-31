terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~>0.51.3"
    }
    # btp = {
    #   source  = "SAP/btp"
    #   version = "0.5.0-beta1"
    # }
  }
}

# Configuration is described in https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs
provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}.hana.ondemand.com"
}

# provider "btp" {
#   globalaccount = var.globalaccount
# }

terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.5.0-beta1"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
}

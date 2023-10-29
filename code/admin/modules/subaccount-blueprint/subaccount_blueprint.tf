# ------------------------------------------------------------------------------------------------------
# Required provider
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.5.0-beta1"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~>0.51.3"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Define local variables for this module
# ------------------------------------------------------------------------------------------------------
locals {
  name_prefix      = "te2023-XP160"
  name_suffix      = format("%03d", var.user_number)
  subaccount_name  = "${local.name_prefix}-${local.name_suffix}"
  cf_instance_name = lower("cf-${local.name_prefix}-${local.name_suffix}")
  cf_org_name      = lower("cforg-${local.name_prefix}-${local.name_suffix}")
}

# ------------------------------------------------------------------------------------------------------
# Create subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "this" {
  name      = local.subaccount_name
  subdomain = replace(lower(local.subaccount_name), "-", "")
  region    = lower(var.region)
}

# ------------------------------------------------------------------------------------------------------
# Set all entitlements in the subaccount
# ------------------------------------------------------------------------------------------------------
# Set entitlement for SAP Build Work Zone, standard edition
resource "btp_subaccount_entitlement" "saplaunchpad" {
  subaccount_id = btp_subaccount.this.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}
# Set entitlement for SAP Private Link
resource "btp_subaccount_entitlement" "privatelink" {
  subaccount_id = btp_subaccount.this.id
  service_name  = "privatelink"
  plan_name     = "standard"
  amount        = 1
}
# Set entitlement for destination service
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.this.id
  service_name  = "destination"
  plan_name     = "lite"
}

resource "btp_subaccount_entitlement" "cfmemory" {
  subaccount_id = btp_subaccount.this.id
  service_name  = "APPLICATION_RUNTIME"
  plan_name     = "MEMORY"
  amount        = 1
}

# ------------------------------------------------------------------------------------------------------
# Assign the subaccount roles to the users
# ------------------------------------------------------------------------------------------------------
# Subaccount Administrator
resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
  subaccount_id        = btp_subaccount.this.id
  role_collection_name = "Subaccount Administrator"
  for_each             = toset(concat(var.admins, ["xp160-${var.user_number}@education.cloud.sap"]))
  user_name            = each.value
  depends_on           = [btp_subaccount.this]
}
# Subaccount Service Administrator
resource "btp_subaccount_role_collection_assignment" "subaccount-service-administrators" {
  subaccount_id        = btp_subaccount.this.id
  role_collection_name = "Subaccount Service Administrator"
  for_each             = toset(concat(var.admins, ["xp160-${var.user_number}@education.cloud.sap"]))
  user_name            = each.value
  depends_on           = [btp_subaccount.this]
}

# ------------------------------------------------------------------------------------------------------
# Create Cloudfoundry environment instance
# ------------------------------------------------------------------------------------------------------
module "cloudfoundry_environment" {
  source                = "../cloudfoundry/cf-envinstance"
  subaccount_id         = btp_subaccount.this.id
  instance_name         = local.cf_instance_name
  cloudfoundry_org_name = local.cf_org_name
  cf_org_members        = concat(var.cf_users, ["xp160-${var.user_number}@education.cloud.sap"])
  depends_on            = [btp_subaccount_entitlement.cfmemory]
}

# ------------------------------------------------------------------------------------------------------
# Create Cloud Foundry space and assign users
# ------------------------------------------------------------------------------------------------------
module "cloudfoundry_space" {
  source              = "../cloudfoundry/cf-space"
  cf_org_id           = module.cloudfoundry_environment.org_id
  cf_org_name         = local.cf_org_name
  region              = lower(var.region)
  name                = "dev"
  cf_space_managers   = concat(var.cf_users, ["xp160-${var.user_number}@education.cloud.sap"])
  cf_space_developers = concat(var.cf_users, ["xp160-${var.user_number}@education.cloud.sap"])
  cf_space_auditors   = concat(var.cf_users, ["xp160-${var.user_number}@education.cloud.sap"])
  cf_username         = var.cf_username
  cf_password         = var.cf_password
}

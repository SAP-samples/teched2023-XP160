###############################################################################################
# Create subaccount
###############################################################################################
resource "btp_subaccount" "this" {
  name      = "XP160-${format("%03d", var.user_number)}"
  subdomain = "teched2023-xp160-${format("%03d", var.user_number)}"
  region    = lower(var.region)
}

###############################################################################################
# Set all entitlements in the subaccount
###############################################################################################
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

###############################################################################################
# Assign the subaccount roles to the users
###############################################################################################
# Subaccount Administrator
resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
  subaccount_id = btp_subaccount.this.id
  role_collection_name = "Subaccount Administrator"
  for_each             = toset(var.admins)
  user_name            = each.value
  depends_on = [
    btp_subaccount.this
  ]
}
# Subaccount Service Administrator
resource "btp_subaccount_role_collection_assignment" "subaccount-service-administrators" {
  subaccount_id = btp_subaccount.this.id
  role_collection_name = "Subaccount Service Administrator"
  for_each             = toset(var.admins)
  user_name            = each.value
  depends_on = [
    btp_subaccount.this
  ]
}

###############################################################################################
# Create Cloudfoundry environment instance in all subaccounts
###############################################################################################
module "cloudfoundry_environment" {
  source = "../envinstance-cloudfoundry/"
  subaccount_id = btp_subaccount.this.id
  instance_name         = lower("cf-inst-te2023-${var.user_number}")
  cloudfoundry_org_name = lower("cf-org-te2023-${var.user_number}")
}

###############################################################################################
# Create Cloud Foundry space and assign users
###############################################################################################
module "cloudfoundry_space" {
  source              = "../cloudfoundry-space/"
  cf_org_id           = module.cloudfoundry_environment.org_id
  name                = "dev"
  cf_space_managers   = var.admins
  cf_space_developers = var.admins
  cf_space_auditors   = var.admins
}

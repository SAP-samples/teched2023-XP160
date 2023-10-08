
# ------------------------------------------------------------------------------------------------------
# 1.4.1 Create service instance for SAP Build Workzone, standard edition
# ------------------------------------------------------------------------------------------------------
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = var.subaccount_id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# 1.4.2 Give user Admin rights for SAP Build Workzone, standard edition
# ------------------------------------------------------------------------------------------------------
# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  subaccount_id        = var.subaccount_id
  role_collection_name = "Launchpad_Admin"
  user_name            = var.username
  depends_on           = [btp_subaccount_subscription.build_workzone]
}

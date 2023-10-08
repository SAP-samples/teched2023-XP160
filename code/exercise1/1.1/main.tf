# ------------------------------------------------------------------------------------------------------
# 1.1.1 Fetch the details around the available Cloudfoundy space called "dev"
# ------------------------------------------------------------------------------------------------------
data "cloudfoundry_space" "dev" {
    name = "dev"
    org = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# 1.1.2 Create service instance for SAP private link
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_privatelink" {
  source       = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id  = data.cloudfoundry_space.dev.id
  service_name = "privatelink"
  plan_name    = "standard"
  parameters   = jsonencode({"resourceId" = "${var.s4_resource_id}"})
}

# ------------------------------------------------------------------------------------------------------
# 1.1.3 Create service key for private link
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_key" "privatelink" {
  name = "privatelink_cf_service_key"
  service_instance = module.create_cf_service_instance_privatelink.id
}

# ------------------------------------------------------------------------------------------------------
# 1.2.1 Create destination service + destination to S/4HANA Cloud system
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_destination" {
  source       = "../../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id  = data.cloudfoundry_space.dev.id
  service_name = "destination"
  plan_name    = "lite"
  parameters = jsonencode({
    HTML5Runtime_enabled = true
    init_data = {
      subaccount = {
        existing_destinations_policy = "update"
        destinations = [
          {
            Name                     = "SAP-Build-Apps-Runtime"
            Type                     = "HTTP"
            Description              = "Endpoint to SAP S/4HANA Cloud System"
            URL                      = "https://sap.com"
            ProxyType                = "Internet"
            Authentication           = "NoAuthentication"
            "HTML5.ForwardAuthToken" = true
          }
        ]
      }
    }
  })
}

# ------------------------------------------------------------------------------------------------------
# 1.3.1 Create service instance for SAP Build Workzone, standard edition
# ------------------------------------------------------------------------------------------------------
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = var.subaccount_id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
}
# Assign users to Role Collection: Launchpad_Admin
#resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
#  for_each             = toset("${var.emergency_admins}")
#  subaccount_id        = btp_subaccount.project.id
#  role_collection_name = "Launchpad_Admin"
#  user_name            = each.value
#  depends_on           = [btp_subaccount_subscription.build_workzone]
#}



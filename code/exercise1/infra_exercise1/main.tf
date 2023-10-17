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
# 1.2.0 Create service key for private link
# ------------------------------------------------------------------------------------------------------
#resource "cloudfoundry_service_key" "privatelink" {
#  name = "privatelink_cf_service_key"
#  service_instance = module.create_cf_service_instance_privatelink.id
#}

# ------------------------------------------------------------------------------------------------------
# 1.3.0 Create destination service + destination to S/4HANA Cloud system
# ------------------------------------------------------------------------------------------------------
#module "create_cf_service_instance_destination" {
#  source       = "../../admin/modules/cloudfoundry/cf-service-instance"
#  cf_space_id  = data.cloudfoundry_space.dev.id
#  service_name = "destination"
#  plan_name    = "lite"
#  parameters = jsonencode({
#    "HTML5Runtime_enabled" : "true",
#    "init_data" : {
#      "instance" : {
#        "existing_destinations_policy" : "update",
#        "destinations" : [
#          {
#            "Authentication"           = "BasicAuthentication",
#            "Name"                     = "s4-on-azure",
#            "Description"              = "SAP S/4HANA Connection via Private Link",
#            "ProxyType"                = "PrivateLink",
#            "Type"                     = "HTTP",
#            "URL"                      = "http://93549d77-6851-4178-ba3c-18720c5e5638.p3.pls.sap.internal:50000",
#            "User"                     = "BPINST"
#            "Password"                 = "${var.s4_connection_pw}"
#            "HTML5.DynamicDestination" = "true"
#            "sap-client"               = "100"
#          }
#        ]
#      }
#    }
#  })
#}

# ------------------------------------------------------------------------------------------------------
# 1.4.1 Create service instance for SAP Build Workzone, standard edition
# ------------------------------------------------------------------------------------------------------
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
#resource "btp_subaccount_subscription" "build_workzone" {
#  subaccount_id = var.subaccount_id
#  app_name      = "SAPLaunchpad"
#  plan_name     = "standard"
#}

# ------------------------------------------------------------------------------------------------------
# 1.4.2 Give user Admin rights for SAP Build Workzone, standard edition
# ------------------------------------------------------------------------------------------------------
# Assign users to Role Collection: Launchpad_Admin
#resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
#  subaccount_id        = var.subaccount_id
#  role_collection_name = "Launchpad_Admin"
#  user_name            = var.username
#  depends_on           = [btp_subaccount_subscription.build_workzone]
#}

# ------------------------------------------------------------------------------------------------------
# 1.4.3 Deploy Cloud Foundry App via cf deploy
# ------------------------------------------------------------------------------------------------------
#resource "null_resource" "cf_app_deploy" {
#  provisioner "local-exec" {
#    command = "cf login -a https://api.cf.${var.region}.hana.ondemand.com -u ${var.username} -p ${var.cf_password}"
#  }
#
#  provisioner "local-exec" {
#    command = "cf deploy ../salesorder-navigator/mta.tar"
#  }
#
#}

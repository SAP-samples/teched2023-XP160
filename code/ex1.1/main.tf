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
  source       = "../admin/modules/cloudfoundry/cf-service-instance"
  cf_space_id  = data.cloudfoundry_space.dev.id
  service_name = "privatelink"
  plan_name    = "standard"
  parameters   = jsonencode({"resourceId" = "${var.s4_resource_id}"})
}

# ------------------------------------------------------------------------------------------------------
# 1.2.0 Create service key for private link
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_key" "privatelink" {
  name = "privatelink_cf_service_key"
  service_instance = module.create_cf_service_instance_privatelink.id
}

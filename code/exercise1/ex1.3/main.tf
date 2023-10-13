
# ------------------------------------------------------------------------------------------------------
# 1.3.0 Create destination service + destination to S/4HANA Cloud system
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_destination" {
  source       = "../admin/modules/cloudfoundry/cf-service-instance"
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
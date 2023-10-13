output "cf_space" {
  value       = data.cloudfoundry_space.dev
  description = "The collected subaccount data"
}

output "cf_service_instance_privatelink" {
  value       = module.create_cf_service_instance_privatelink
  description = "The details of the privatelink service instance in Cloudfoundry environment."
}

output "cf_privatelink_service_key" {
  value       = cloudfoundry_service_key.privatelink
  sensitive   = true
  description = "The details of the service key for the privatelink service instance in Cloudfoundry environment."
}

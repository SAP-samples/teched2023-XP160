output "subaccount_id" {
  value       = btp_subaccount.this.id
  description = "The ID of the subaccount."
}

output "cloudfoundry_instance" {
  value       = module.cloudfoundry_environment
  description = "The metadata of the cloudfoundry instance."
}

output "cloudfoundry_space" {
  value       = module.cloudfoundry_space
  description = "The metadata of the cloudfoundry space."
}

output "cf_service_instance"{
  value       = module.create_cf_service_instance_privatelink
  description = "The metadata of the created cloudfoundry service instance."
}
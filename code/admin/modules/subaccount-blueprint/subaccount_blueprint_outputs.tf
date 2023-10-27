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

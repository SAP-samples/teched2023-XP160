output "id" {
  value       = cloudfoundry_service_instance.service.id
  description = "The id of the created service instance."
}
output "service_details" {
  value       = cloudfoundry_service_instance.service
  description = "All details of the created service instance."
}

variable "service_name" {
  type = string
  description = "The technical name of the service"
}


variable "service_instance_name" {
  type = string
  description = "The name of the service instance"
}

variable "plan_name" {
  type = string
    description = "The name of the service plan"

}

variable "parameters" {
  type = string
  description = "The service parameters"
}

variable "cf_space_id" {
  type = string
  description = "The ID of the CF space the service should be created in."
}

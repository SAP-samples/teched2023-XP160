
module "project_setup" {
  count  = 2
  source = "./modules/subaccount-blueprint/"

  user_number    = format("%06d", count.index + 1)
  globalaccount  = var.globalaccount
  region         = var.region
  admins         = var.subaccount_users
  cf_users       = var.cf_users
  s4_resource_id = var.s4_resource_id
}
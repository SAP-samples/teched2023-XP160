
module "project_setup" {
  count  = 1
  source = "./modules/subaccount-blueprint/"

  user_number   = format("%06d", count.index + 1)
  globalaccount = var.globalaccount
  region        = var.region
  admins        = var.subaccount_users
  cf_users      = var.cf_users
}

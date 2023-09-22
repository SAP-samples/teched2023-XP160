module "project_setup" {
  count  = 2
  source = "./modules/setup-subaccount/"

  user_number           = "${format("%03d", count.index + 1)}"
  globalaccount         = var.globalaccount
  region                = var.region
  admins                = var.subaccount_users
  cf_users              = var.cf_users
  azure_subscription_id = var.azure_subscription_id
}

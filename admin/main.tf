module "project_setup" {
  count  = 1
  source = "./modules/setup-subaccount/"

  user_number   = "${format("%03d", count.index + 1)}"
  
  globalaccount = var.globalaccount
  region        = var.region
  admins        = toset(var.users)
}

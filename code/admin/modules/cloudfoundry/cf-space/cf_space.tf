# ------------------------------------------------------------------------------------------------------
# Required provider
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~>0.51.3"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "space" {
  name = var.name
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# Create the CF users
# ------------------------------------------------------------------------------------------------------
/*
resource "cloudfoundry_space_users" "space-users" {
  space      = cloudfoundry_space.space.id
  managers   = var.cf_space_managers
  developers = var.cf_space_developers
  auditors   = var.cf_space_auditors
}
*/

locals {
  origin             = "sap.ids"
  roleSpaceManager   = "SpaceManager"
  roleSpaceDeveloper = "SpaceDeveloper"
  roleSpaceAuditor   = "SpaceAuditor"
}

resource "null_resource" "cf_user_assign_developer" {
  for_each = toset(var.cf_space_developers)

  provisioner "local-exec" {
    command = "cf login -a https://api.cf.${var.region}.hana.ondemand.com -u ${var.cf_username} -p ${var.cf_password}"
  }
  provisioner "local-exec" {
    command = "cf set-space-role  ${each.value} ${var.cf_org_name} ${var.name} ${local.roleSpaceDeveloper}  --origin ${local.origin}"
  }
  depends_on = [cloudfoundry_space.space]
}

resource "null_resource" "cf_user_assign_auditor" {
  for_each = toset(var.cf_space_auditors)

  provisioner "local-exec" {
    command = "cf login -a https://api.cf.${var.region}.hana.ondemand.com -u ${var.cf_username} -p ${var.cf_password}"
  }
  provisioner "local-exec" {
    command = "cf set-space-role  ${each.value} ${var.cf_org_name} ${var.name} ${local.roleSpaceAuditor}  --origin ${local.origin}"
  }
  depends_on = [cloudfoundry_space.space]
}

resource "null_resource" "cf_user_assign_manager" {
  for_each = toset(var.cf_space_managers)
  provisioner "local-exec" {
    command = "cf login -a https://api.cf.${var.region}.hana.ondemand.com -u ${var.cf_username} -p ${var.cf_password}"
  }
  provisioner "local-exec" {
    command = "cf set-space-role ${each.value} ${var.cf_org_name} ${var.name} ${local.roleSpaceManager} --origin ${local.origin}"
  }
  depends_on = [cloudfoundry_space.space]
}

terraform {
  required_providers {
    azurerm = {
      version = "~>3.74.0"
      source  = "hashicorp/azurerm"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Deploy Azure Fucntions app (Linux)
# ------------------------------------------------------------------------------------------------------
resource "azurerm_linux_function_app" "function_app" {
  name                       = var.function_name
  resource_group_name        = var.rg_name
  location                   = var.location
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  service_plan_id            = var.service_plan_id
  tags                       = merge(var.tags, { "azd-service-name" : "${var.azd_service_name}" })
  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "true"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.application_insights_connection_string
    "AzureWebJobsFeatureFlags"              = "EnableWorkerIndexing"
  }
  site_config {
    ftps_state = "FtpsOnly"
    application_stack {

      node_version = "18"
    }
    use_32_bit_worker = false
    always_on         = false
  }
  identity {
    type = "SystemAssigned"
  }
}

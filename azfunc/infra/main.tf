locals {
  tags                  = { azd-env-name : var.environment_name }
  sha                   = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token        = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
  abbr_key_vault_vaults = "kv-"
}

# ------------------------------------------------------------------------------------------------------
# Deploy resource Group
# ------------------------------------------------------------------------------------------------------
resource "azurecaf_name" "rg_name" {
  name          = var.environment_name
  resource_type = "azurerm_resource_group"
  random_length = 0
  clean_input   = true
}

resource "azurerm_resource_group" "rg" {
  name     = azurecaf_name.rg_name.result
  location = var.location
  tags     = local.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy application insights
# ------------------------------------------------------------------------------------------------------
module "applicationinsights" {
  source           = "./modules/applicationinsights"
  location         = var.location
  rg_name          = azurerm_resource_group.rg.name
  environment_name = var.environment_name
  workspace_id     = module.loganalytics.LOGANALYTICS_WORKSPACE_ID
  tags             = azurerm_resource_group.rg.tags
  resource_token   = local.resource_token
}

# ------------------------------------------------------------------------------------------------------
# Deploy log analytics
# ------------------------------------------------------------------------------------------------------
module "loganalytics" {
  source         = "./modules/loganalytics"
  location       = var.location
  rg_name        = azurerm_resource_group.rg.name
  tags           = azurerm_resource_group.rg.tags
  resource_token = local.resource_token
}

# ------------------------------------------------------------------------------------------------------
# Deploy key vault
# ------------------------------------------------------------------------------------------------------
/* TODO KEYVAULT  Usgae of System Assigned Identity
module "keyvault" {
  source                   = "./modules/keyvault"
  location                 = var.location
  principal_id             = var.principal_id
  rg_name                  = azurerm_resource_group.rg.name
  tags                     = azurerm_resource_group.rg.tags
  resource_token           = local.resource_token
  access_policy_object_ids = [azurerm_linux_function_app.tracking_function_app.identity.0.principal_id]
  secrets = [
    {
      name  = "${local.abbr_key_vault_vaults}secret-apikey"
      value = var.tracking_api_key
    }
  ]
}
*/

# ------------------------------------------------------------------------------------------------------
# Deploy a storage account
# ------------------------------------------------------------------------------------------------------
# Generate random ID to avoid naming clashes for storage account
resource "random_id" "storage_account_id" {
  byte_length = 8
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "fte${lower(random_id.storage_account_id.hex)}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags                     = azurerm_resource_group.rg.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy app service plan
# ------------------------------------------------------------------------------------------------------
module "appserviceplan" {
  source         = "./modules/appserviceplan"
  location       = var.location
  rg_name        = azurerm_resource_group.rg.name
  tags           = azurerm_resource_group.rg.tags
  resource_token = local.resource_token
  sku_name       = var.sku_name
}

# ------------------------------------------------------------------------------------------------------
# Deploy Function app
# ------------------------------------------------------------------------------------------------------
resource "azurerm_linux_function_app" "tracking_function_app" {
  name                       = "azfunc-tracking"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  service_plan_id            = module.appserviceplan.APPSERVICE_PLAN_ID
  tags                       = merge(local.tags, { "azd-service-name" : "azfunc-tracking-status" })
  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "true"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.applicationinsights.APPLICATIONINSIGHTS_CONNECTION_STRING
    #"AZURE_KEY_VAULT_ENDPOINT"              = module.keyvault.AZURE_KEY_VAULT_ENDPOINT
    #"TRACKING_API_KEY"                      = "@Microsoft.KeyVault(SecretUri=${module.keyvault.AZURE_KEY_VAULT_ENDPOINT}secrets/${local.abbr_key_vault_vaults}secret-apikey)"
    "TRACKING_URL"                          = var.tracking_api_endpoint
    "USE_MOCK"                              = var.use_mock_response
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

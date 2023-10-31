locals {
  tags                         = { azd-env-name : var.environment_name }
  sha                          = base64encode(sha256("${var.environment_name}${var.location}))
  resource_token               = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
  cosmos_connection_string_key = "AZURE-COSMOS-CONNECTION-STRING"
}

variable "resource_group_name" {}

variable "resource_name" {}

variable "location" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
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

# ------------------------------------------------------------------------------------------------------
# Deploy application insights
# ------------------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------------------
# Deploy log analytics
# ------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------
# Deploy key vault
# ------------------------------------------------------------------------------------------------------
module "keyvault" {
  source                   = "./modules/keyvault"
  location                 = var.location
  rg_name                  = azurerm_resource_group.rg.name
  tags                     = azurerm_resource_group.rg.tags
  resource_token           = local.resource_token
}

# ------------------------------------------------------------------------------------------------------
# Deploy cosmos
# ------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------
# Deploy app service plan
# ------------------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------------------
# Deploy app service web app
# ------------------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------------------
# Deploy app service api
# ------------------------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------------------
# Deploy app service apim
# ------------------------------------------------------------------------------------------------------
#module "apim" {
#  count                     = var.useAPIM ? 1 : 0
#  source                    = "./modules/apim"
#  name                      = "apim-${local.resource_token}"
#  location                  = var.location
#  rg_name                   = azurerm_resource_group.rg.name
# tags                      = merge(local.tags, { "azd-service-name" : var.environment_name })
#  application_insights_name = module.applicationinsights.APPLICATIONINSIGHTS_NAME
#  sku                       = "Consumption"
#}

# ------------------------------------------------------------------------------------------------------
# Deploy app service apim-api
# ------------------------------------------------------------------------------------------------------
#module "apimApi" {
#  count                    = var.useAPIM ? 1 : 0
#  source                   = "./modules/apim-api"
#  name                     = module.apim[0].APIM_SERVICE_NAME
#  rg_name                  = azurerm_resource_group.rg.name
#  web_front_end_url        = module.web.URI
#  api_management_logger_id = module.apim[0].API_MANAGEMENT_LOGGER_ID
#  api_name                 = "todo-api"
#  api_display_name         = "Simple Todo API"
#  api_path                 = "todo"
#  api_backend_url          = module.api.URI
#}

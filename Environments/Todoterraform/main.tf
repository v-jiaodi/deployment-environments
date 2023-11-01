
terraform {
  required_providers {
    azurerm = {
      version = "~>3.47.0"
      source  = "hashicorp/azurerm"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.24"
    }
  }
}
provider "azurerm" {
  features {}

  skip_provider_registration = true
}

# ------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------

#locals {
#  tags                         = { azd-env-name : var.environment_name }
#  sha                          = base64encode(sha256("${var.environment_name}${var.location}))
#  resource_token               = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
#  cosmos_connection_string_key = "AZURE-COSMOS-CONNECTION-STRING"
#}
variable "tags" { azd-env-name : var.environment_name }
variable "resource_group_name" {}

variable "resource_name" {}

variable "location" {}
variable sha = base64encode(sha256("${var.environment_name}${var.location}))
variable resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
# ------------------------------------------------------------------------------------------------------
# Deploy service_plan
# ------------------------------------------------------------------------------------------------------
resource "azurecaf_name" "plan_name" {
  name          = var.resource_token
  resource_type = "azurerm_app_service_plan"
  random_length = 0
  clean_input   = true
}
variable "sku_name" {
  description = "The SKU for the plan."
  type        = string
  default     = "B1"
}

variable "os_type" {
  description = "The O/S type for the App Services to be hosted in this plan."
  type        = string
  default     = "Linux"
}
resource "azurerm_service_plan" "service_plan" {
  name                = azurecaf_name.plan_name.result
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = var.os_type
  os_type             = var.sku_name
  tags = var.tags
}

output "APPSERVICE_PLAN_ID" {
  value     = azurerm_service_plan.plan.id
  sensitive = true
}
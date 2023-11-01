terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

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
resource "azurerm_service_plan" "service_plan" {
  name                = azurecaf_name.plan_name.result
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = "B1"
  os_type             = "Linux"
}

output "APPSERVICE_PLAN_ID" {
  value     = azurerm_service_plan.plan.id
  sensitive = true
}
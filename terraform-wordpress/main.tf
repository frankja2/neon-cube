# ==============================================================================
# Azure WordPress Deployment - Main Configuration
# Region: polandcentral
#
# Region notes (polandcentral):
#   - GA region with 3 Availability Zones, data residency in Poland
#   - App Service, MySQL Flexible Server, VNet — all available
#   - Some services NOT available: Static Web Apps, Databricks (verify current state)
#   - Azure AI Search has lower storage limits vs older EU regions
#   - New tenants may need to request access if region-restriction policy is active
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Uncomment and configure for remote state (recommended for team work)
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "tfstateXXXXX"
  #   container_name       = "tfstate"
  #   key                  = "wordpress.tfstate"
  # }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

# ------------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------------

locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  default_tags = merge(var.tags, {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  })
}

# ------------------------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------------------------

resource "azurerm_resource_group" "wordpress" {
  name     = "rg-${local.resource_prefix}-wordpress"
  location = var.location
  tags     = local.default_tags
}

# ==============================================================================
# Azure WordPress Deployment - Variables
# Region: polandcentral
# ==============================================================================

# ------------------------------------------------------------------------------
# Azure Account & Authentication
# ------------------------------------------------------------------------------

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Azure Service Principal Client ID (optional - for non-interactive auth)"
  type        = string
  default     = null
  sensitive   = true
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret (optional - for non-interactive auth)"
  type        = string
  default     = null
  sensitive   = true
}

# ------------------------------------------------------------------------------
# General
# ------------------------------------------------------------------------------

variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "wp"

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.project_name))
    error_message = "Project name must be 2-10 lowercase alphanumeric characters."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region for resources. Default: polandcentral"
  type        = string
  default     = "polandcentral"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Networking
# ------------------------------------------------------------------------------

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_app_address_prefix" {
  description = "Address prefix for the App Service subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_db_address_prefix" {
  description = "Address prefix for the MySQL database subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# ------------------------------------------------------------------------------
# MySQL Flexible Server
# ------------------------------------------------------------------------------

variable "mysql_admin_username" {
  description = "MySQL administrator username"
  type        = string
  default     = "wpadmin"

  validation {
    condition     = !contains(["admin", "administrator", "root", "sa", "azure_superuser"], var.mysql_admin_username)
    error_message = "MySQL admin username cannot be a reserved name."
  }
}

variable "mysql_admin_password" {
  description = "MySQL administrator password (min 8 chars, must include uppercase, lowercase, number, special char)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.mysql_admin_password) >= 8
    error_message = "MySQL admin password must be at least 8 characters."
  }
}

variable "mysql_sku_name" {
  description = "MySQL Flexible Server SKU. Use B_Standard_B1ms for dev, GP_Standard_D2ads_v5 for prod"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.21"
}

variable "mysql_storage_size_gb" {
  description = "MySQL storage size in GB"
  type        = number
  default     = 20
}

variable "mysql_backup_retention_days" {
  description = "MySQL backup retention in days (1-35)"
  type        = number
  default     = 7

  validation {
    condition     = var.mysql_backup_retention_days >= 1 && var.mysql_backup_retention_days <= 35
    error_message = "Backup retention must be between 1 and 35 days."
  }
}

variable "mysql_database_name" {
  description = "Name of the WordPress database"
  type        = string
  default     = "wordpress"
}

# ------------------------------------------------------------------------------
# App Service (WordPress)
# ------------------------------------------------------------------------------

variable "app_service_sku_name" {
  description = "App Service Plan SKU. B1 for dev, P1v3 for prod. Note: VNet integration requires at least B1"
  type        = string
  default     = "B1"
}

variable "wordpress_docker_image" {
  description = "WordPress Docker image name with tag"
  type        = string
  default     = "appsvc/wordpress-alpine-php:8.2"
}

variable "wordpress_title" {
  description = "WordPress site title"
  type        = string
  default     = "My WordPress Site"
}

variable "wordpress_admin_email" {
  description = "WordPress admin email"
  type        = string
  default     = "admin@example.com"
}

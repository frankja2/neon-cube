# ==============================================================================
# App Service Plan + WordPress Web App
# ==============================================================================

# ------------------------------------------------------------------------------
# App Service Plan (Linux)
# ------------------------------------------------------------------------------

resource "azurerm_service_plan" "wordpress" {
  name                = "asp-${local.resource_prefix}"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
  os_type             = "Linux"
  sku_name            = var.app_service_sku_name
  tags                = local.default_tags
}

# ------------------------------------------------------------------------------
# Linux Web App - WordPress
# ------------------------------------------------------------------------------

resource "azurerm_linux_web_app" "wordpress" {
  name                      = "app-${local.resource_prefix}-wordpress"
  location                  = azurerm_resource_group.wordpress.location
  resource_group_name       = azurerm_resource_group.wordpress.name
  service_plan_id           = azurerm_service_plan.wordpress.id
  virtual_network_subnet_id = azurerm_subnet.app_service.id
  https_only                = true
  tags                      = local.default_tags

  site_config {
    always_on         = true
    ftps_state        = "Disabled"
    minimum_tls_version = "1.2"
    health_check_path = "/"

    application_stack {
      docker_image_name   = var.wordpress_docker_image
      docker_registry_url = "https://mcr.microsoft.com"
    }
  }

  app_settings = {
    # WordPress Database Configuration
    DATABASE_HOST     = azurerm_mysql_flexible_server.wordpress.fqdn
    DATABASE_NAME     = azurerm_mysql_flexible_database.wordpress.name
    DATABASE_USERNAME = var.mysql_admin_username
    DATABASE_PASSWORD = var.mysql_admin_password

    # WordPress Settings
    WORDPRESS_TITLE       = var.wordpress_title
    WORDPRESS_ADMIN_EMAIL = var.wordpress_admin_email

    # WordPress local storage cache
    WORDPRESS_LOCAL_STORAGE_CACHE_ENABLED = "true"

    # Disable ARR Affinity for better performance behind load balancer
    WEBSITE_ENABLE_APP_SERVICE_STORAGE = "true"
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "MySQL"
    value = "Database=${azurerm_mysql_flexible_database.wordpress.name};Data Source=${azurerm_mysql_flexible_server.wordpress.fqdn};User Id=${var.mysql_admin_username};Password=${var.mysql_admin_password}"
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }
}

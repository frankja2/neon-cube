# ==============================================================================
# MySQL Flexible Server for WordPress
# ==============================================================================

resource "azurerm_mysql_flexible_server" "wordpress" {
  name                   = "mysql-${local.resource_prefix}"
  location               = azurerm_resource_group.wordpress.location
  resource_group_name    = azurerm_resource_group.wordpress.name
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  sku_name               = var.mysql_sku_name
  version                = var.mysql_version
  backup_retention_days  = var.mysql_backup_retention_days
  delegated_subnet_id    = azurerm_subnet.mysql.id
  private_dns_zone_id    = azurerm_private_dns_zone.mysql.id
  zone                   = "1"

  storage {
    size_gb = var.mysql_storage_size_gb
  }

  tags = local.default_tags

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]
}

# ------------------------------------------------------------------------------
# WordPress Database
# ------------------------------------------------------------------------------

resource "azurerm_mysql_flexible_database" "wordpress" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.wordpress.name
  server_name         = azurerm_mysql_flexible_server.wordpress.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# ------------------------------------------------------------------------------
# MySQL Configuration - Disable require_secure_transport for initial setup
# Re-enable after WordPress installation is complete
# ------------------------------------------------------------------------------

resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = azurerm_resource_group.wordpress.name
  server_name         = azurerm_mysql_flexible_server.wordpress.name
  value               = "OFF"
}

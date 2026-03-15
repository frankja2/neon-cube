# ==============================================================================
# Outputs
# ==============================================================================

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.wordpress.name
}

output "wordpress_url" {
  description = "URL of the WordPress site"
  value       = "https://${azurerm_linux_web_app.wordpress.default_hostname}"
}

output "wordpress_app_name" {
  description = "Name of the WordPress App Service"
  value       = azurerm_linux_web_app.wordpress.name
}

output "mysql_server_fqdn" {
  description = "FQDN of the MySQL Flexible Server (private, accessible only from VNet)"
  value       = azurerm_mysql_flexible_server.wordpress.fqdn
  sensitive   = true
}

output "mysql_server_name" {
  description = "Name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.wordpress.name
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.wordpress.name
}

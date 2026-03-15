# ==============================================================================
# Networking - VNet, Subnets, Private DNS
# ==============================================================================

# ------------------------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------------------------

resource "azurerm_virtual_network" "wordpress" {
  name                = "vnet-${local.resource_prefix}"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
  address_space       = [var.vnet_address_space]
  tags                = local.default_tags
}

# ------------------------------------------------------------------------------
# Subnet for App Service (VNet Integration)
# ------------------------------------------------------------------------------

resource "azurerm_subnet" "app_service" {
  name                 = "snet-appservice"
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
  address_prefixes     = [var.subnet_app_address_prefix]

  delegation {
    name = "app-service-delegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

# ------------------------------------------------------------------------------
# Subnet for MySQL Flexible Server
# ------------------------------------------------------------------------------

resource "azurerm_subnet" "mysql" {
  name                 = "snet-mysql"
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
  address_prefixes     = [var.subnet_db_address_prefix]

  delegation {
    name = "mysql-flexible-server-delegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

# ------------------------------------------------------------------------------
# Private DNS Zone for MySQL Flexible Server
# ------------------------------------------------------------------------------

resource "azurerm_private_dns_zone" "mysql" {
  name                = "${local.resource_prefix}.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.wordpress.name
  tags                = local.default_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns-link"
  resource_group_name   = azurerm_resource_group.wordpress.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.wordpress.id
}

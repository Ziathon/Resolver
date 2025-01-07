resource "azurerm_resource_group" "resolver" {
  name     = "resolver-resources"
  location = var.location
}

resource "azurerm_virtual_network" "resolver" {
  name                = "resolver"
  resource_group_name = azurerm_resource_group.resolver.name
  location            = azurerm_resource_group.resolver.location
  address_space       = var.AddressSpace
}

resource "azurerm_private_dns_resolver" "test" {
  name                = "resolver"
  resource_group_name = azurerm_resource_group.resolver.name
  location            = azurerm_resource_group.resolver.location
  virtual_network_id  = azurerm_virtual_network.resolver.id
}

## Inbound Endpoint

resource "azurerm_resource_group" "resolver" {
  name     = "resolver-resources"
  location = var.location
}

resource "azurerm_virtual_network" "resolver" {
  name                = "resolver"
  resource_group_name = azurerm_resource_group.resolver.name
  location            = azurerm_resource_group.resolver.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_private_dns_resolver" "resolver" {
  name                = "resolver"
  resource_group_name = azurerm_resource_group.resolver.name
  location            = azurerm_resource_group.resolver.location
  virtual_network_id  = azurerm_virtual_network.resolver.id
}

resource "azurerm_subnet" "resolver" {
  name                 = "inbounddns"
  resource_group_name  = azurerm_resource_group.resolver.name
  virtual_network_name = azurerm_virtual_network.resolver.name
  address_prefixes     = var.AddressSpace

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "resolver" {
  name                    = "resolver-drie"
  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  location                = azurerm_private_dns_resolver.resolver.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.resolver.id
  }
  tags = {
    key = "value"
  }
}

## Outbound Endpoint

resource "azurerm_resource_group" "resolver" {
  name     = "resolver-resources"
  location = var.location
}

resource "azurerm_virtual_network" "resolver" {
  name                = "resolver-vnet"
  resource_group_name = azurerm_resource_group.resolver.name
  location            = azurerm_resource_group.resolver.location
  address_space       = var.AddressSpace
}

resource "azurerm_subnet" "resolver" {
  name                 = "outbounddns"
  resource_group_name  = azurerm_resource_group.resolver.name
  virtual_network_name = azurerm_virtual_network.resolver.name
  address_prefixes     = var.AddressSpace

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}


resource "azurerm_private_dns_resolver" "resolver" {
  name                = "Outbound Resolver"
  resource_group_name = azurerm_resource_group.resolver.name
  location            = azurerm_resource_group.resolver.location
  virtual_network_id  = azurerm_virtual_network.resolver.id
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "resolver" {
  name                    = "resolver-endpoint"
  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  location                = azurerm_private_dns_resolver.resolver.location
  subnet_id               = azurerm_subnet.resolver.id
  tags = {
    key = "value"
  }
}
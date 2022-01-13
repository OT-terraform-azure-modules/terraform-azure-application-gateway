provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["192.168.0.0/16"]
}

module "agw" {
  source                      = "../"
  agw_name                    = var.agw_name
  agw_resource_group_name     = azurerm_resource_group.example.name
  agw_resource_group_location = azurerm_resource_group.example.location
  agw_vnet_name               = azurerm_virtual_network.example.name
  request_routing_rule        = var.agw_request_routing_rule
  http_listener               = var.agw_http_listener
  backend_http_settings       = var.agw_backend_http_settings
  backend_address_pool        = var.agw_backend_address_pool
  frontend_port               = var.agw_frontend_port
  sku                         = var.agw_sku
  agw_address_prefix          = var.agw_address_prefix
  agw_security_rule           = var.agw_security_rule

  tag_map = var.tag_map
}
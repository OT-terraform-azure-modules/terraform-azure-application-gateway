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
  agw_resource_group_name     = data.terraform_remote_state.network.outputs.resource_group_name[0]
  agw_resource_group_location = data.terraform_remote_state.network.outputs.vnet_location[0]
  agw_vnet_name               = data.terraform_remote_state.network.outputs.vnet_name[0]
  request_routing_rule        = var.agw_request_routing_rule
  http_listener               = var.agw_http_listener
  backend_http_settings       = var.agw_backend_http_settings
  backend_address_pool        = var.backend_address_pool

  frontend_port               = var.agw_frontend_port
  sku                         = var.agw_sku
  agw_address_prefix          = var.agw_address_prefix
  agw_security_rule           = var.agw_security_rule
  public_ip_allocation_method = var.public_ip_allocation_method
  pip_sku                     = var.pip_sku
  tag_map                     = var.tag_map
  agw_pubip_name              = var.agw_pubip_name
  agw_nsg_name                = var.agw_nsg_name
  agw_subnet_name             = var.agw_subnet_name
  waf_configuration           = var.waf_configuration
  probes                      = var.probes
  redirect_configuration      = var.redirect_configuration
  ssl_certificates            = var.ssl_certificates
  use_waf_policy              = var.use_waf_policy
  firewall_policy_id          = null
}


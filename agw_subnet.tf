resource "azurerm_subnet" "agw_subnet" {
  name                 = var.agw_subnet_name
  resource_group_name  = var.agw_resource_group_name
  virtual_network_name = var.agw_vnet_name
  address_prefixes     = var.agw_address_prefix
}




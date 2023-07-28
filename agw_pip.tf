resource "azurerm_public_ip" "pip" {
  name                = var.agw_name
  location            = var.agw_resource_group_location
  resource_group_name = var.agw_resource_group_name
  allocation_method   = var.public_ip_allocation_method # Default is Dynamic
  domain_name_label   = var.agw_name
  sku                 = var.pip_sku 
  tags                = var.tag_map
}



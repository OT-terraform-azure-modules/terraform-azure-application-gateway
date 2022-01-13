resource "azurerm_network_security_group" "agw_nsg" {
  name                = var.agw_name
  location            = var.agw_resource_group_location
  resource_group_name = var.agw_resource_group_name

  dynamic "security_rule" {
    for_each = var.agw_security_rule
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
  tags = var.tag_map
}

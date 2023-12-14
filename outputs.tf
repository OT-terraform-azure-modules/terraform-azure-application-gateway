output "agw_id" {
  value = azurerm_application_gateway.agw.id
  description = "ID of the Application Gateway"
}

output "agw_subnet_id" {
  value       = azurerm_subnet.agw_subnet.id
  description = "ID of the Subnet of Application Gateway"
}

output "nsg_id" {
  value = azurerm_network_security_group.agw_nsg.id
  description = "ID of the Network Security Group of Application Gateway"
}

output  backend_address_pool_id {
  value       = azurerm_application_gateway.agw.request_routing_rule[*].backend_address_pool_id
  description = "The id of aap_gw_backend"
}


output "agw_pubip" {
  value = azurerm_public_ip.pip.ip_address
}
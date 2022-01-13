resource "azurerm_application_gateway" "agw" {
  name                = var.agw_name
  resource_group_name = var.agw_resource_group_name
  location            = var.agw_resource_group_location

  sku {
    name     = lookup(var.sku, "name")
    tier     = lookup(var.sku, "tier")
    capacity = lookup(var.sku, "capacity")
  }

  gateway_ip_configuration {
    name      = "${var.agw_name}_ip"
    subnet_id = azurerm_subnet.agw_subnet.id
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  frontend_ip_configuration {
    name                 = azurerm_public_ip.pip.name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool
    content {
      name  = backend_address_pool.value.name
      fqdns = backend_address_pool.value.fqdns
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      path                  = backend_http_settings.value.path
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listener
    content {
      name                           = lookup(http_listener.value, "name")
      frontend_ip_configuration_name = lookup(http_listener.value, "frontend_ip_configuration_name")
      host_name                      = lookup(http_listener.value, "host_name")
      frontend_port_name             = lookup(http_listener.value, "frontend_port_name")
      protocol                       = lookup(http_listener.value, "protocol", "http")
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      require_sni                    = lookup(http_listener.value, "require_sni", null)
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }
  }

  tags = var.tag_map
}

resource "azurerm_subnet_network_security_group_association" "agw_nsg" {
  subnet_id                 = azurerm_subnet.agw_subnet.id
  network_security_group_id = azurerm_network_security_group.agw_nsg.id
}
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
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
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
      backend_address_pool_name  = lookup(request_routing_rule.value, "backend_address_pool_name", null)
      backend_http_settings_name = lookup(request_routing_rule.value, "backend_http_settings_name", null)
      priority                   = request_routing_rule.value.priority
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null)
    }
  }

  firewall_policy_id = var.use_waf_policy == true ? var.firewall_policy_id : null

  dynamic "waf_configuration" {
    for_each = var.waf_configuration != null ? [var.waf_configuration] : []
    content {
      enabled                  = true
      firewall_mode            = lookup(waf_configuration.value, "firewall_mode", "Detection")
      rule_set_type            = "OWASP"
      rule_set_version         = lookup(waf_configuration.value, "rule_set_version", "3.2")
      file_upload_limit_mb     = lookup(waf_configuration.value, "file_upload_limit_mb", 100)
      request_body_check       = lookup(waf_configuration.value, "request_body_check", true)
      max_request_body_size_kb = lookup(waf_configuration.value, "max_request_body_size_kb", 128)

      dynamic "disabled_rule_group" {
        for_each = waf_configuration.value.disabled_rule_group
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = disabled_rule_group.value.rules
        }
      }

      dynamic "exclusion" {
        for_each = waf_configuration.value.exclusion
        content {
          match_variable          = exclusion.value.match_variable
          selector_match_operator = exclusion.value.selector_match_operator
          selector                = exclusion.value.selector
        }
      }
    }  
  } 

  dynamic "probe" {
    for_each = var.probes
    content {
      name                  = probe.value.name
      protocol              = probe.value.protocol
      host                  = probe.value.host
      path                  = probe.value.path
      port                  = probe.value.port
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
      interval              = probe.value.interval
      timeout               = probe.value.timeout
      unhealthy_threshold   = probe.value.unhealthy_threshold

      match {
        status_code = probe.value.match_status_code
      }
    }
  }

  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration
    content {
      name                 = lookup(redirect_configuration.value, "name", null)
      redirect_type        = lookup(redirect_configuration.value, "redirect_type", "Permanent")
      target_listener_name = lookup(redirect_configuration.value, "target_listener_name", null)
      target_url           = lookup(redirect_configuration.value, "target_url", null)
      include_path         = lookup(redirect_configuration.value, "include_path", "true")
      include_query_string = lookup(redirect_configuration.value, "include_query_string", "true")
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                = ssl_certificate.value.name
      data                = ssl_certificate.value.key_vault_secret_id == null ? filebase64(ssl_certificate.value.data) : null
      password            = ssl_certificate.value.key_vault_secret_id == null ? ssl_certificate.value.password : null
      key_vault_secret_id = lookup(ssl_certificate.value, "key_vault_secret_id", null)
    }
  }

  tags = var.tag_map
}

resource "azurerm_subnet_network_security_group_association" "agw_nsg" {
  subnet_id                 = azurerm_subnet.agw_subnet.id
  network_security_group_id = azurerm_network_security_group.agw_nsg.id
}


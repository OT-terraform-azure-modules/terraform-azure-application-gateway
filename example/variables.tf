variable "agw_name" {
  default = "buildpiper-agwnew"
}

variable "agw_ip_name" {
  default = "agw-ip"
}

variable "agw_subnet_name" {
  default = "agw_subnet"
}

variable "agw_address_prefix" {
  default = ["192.168.2.0/24"]
}

variable "agw_security_rule" {
  default = [{
    name                       = "http"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = 80
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    },
    {
      name                       = "https"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = 443
      destination_port_range     = 443
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }]
}

variable "agw_sku" {
  type        = map(string)
  description = "Map to define the sku of the Application Gateway: Standard(Small, Medium, Large) or WAF (Medium, Large), and the capacity (between 1 and 10)"
  default = {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }
}

variable "agw_frontend_port" {
  type        = any
  description = "List of FrontEnd Ports and Names"
  default = [{
    name = "agw_frontendPort"
    port = 80
  }]
}

variable "agw_backend_address_pool" {
  type        = any
  description = "List of Backend Address Pool"
  default = [{
    name  = "Buildpiper"
    fqdns = ["buildpiper.com"]
    },
    {
      name  = "Nexus"
      fqdns = ["nexus.com"]
  }]
}

variable "agw_backend_http_settings" {
  type        = any
  description = "List of Backend HTTP Settings"
  default = [{
    name                  = "buildpiper"
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
    },
    {
      name                  = "api-buildpiper"
      cookie_based_affinity = "Disabled"
      path                  = ""
      port                  = 9001
      protocol              = "Http"
      request_timeout       = 20
    },
    {
      name                  = "nexus-cli"
      cookie_based_affinity = "Disabled"
      path                  = ""
      port                  = 8081
      protocol              = "Http"
      request_timeout       = 20
    },
    {
      name                  = "nexus-ui"
      cookie_based_affinity = "Disabled"
      path                  = ""
      port                  = 8082
      protocol              = "Http"
      request_timeout       = 20
  }]
}

variable "agw_http_listener" {
  type        = any
  description = "List of HTTP Listners"
  default = [{
    name                           = "buildpiper"
    frontend_ip_configuration_name = "buildpiper-agwnew" # This will be na name of AGW_PIP
    host_name                      = "buildpiperui.com"
    frontend_port_name             = "agw_frontendPort"
    protocol                       = "Http"
    },
    {
      name                           = "api-buildpiper"
      frontend_ip_configuration_name = "buildpiper-agwnew"
      host_name                      = "buildpiperapi.com"
      frontend_port_name             = "agw_frontendPort"
      protocol                       = "Http"
    },
    {
      name                           = "nexuscli"
      frontend_ip_configuration_name = "buildpiper-agwnew"
      host_name                      = "nuxuscli.com"
      frontend_port_name             = "agw_frontendPort"
      protocol                       = "Http"
    },
    {
      name                           = "nexusui"
      frontend_ip_configuration_name = "buildpiper-agwnew"
      host_name                      = "nexusui.com"
      frontend_port_name             = "agw_frontendPort"
      protocol                       = "Http"
  }]
}

variable "agw_request_routing_rule" {
  type        = any
  description = "List of Request Routing Rules"
  default = [{
    name                       = "Buildpiper"
    rule_type                  = "Basic"
    http_listener_name         = "buildpiper"
    backend_address_pool_name  = "Buildpiper"
    backend_http_settings_name = "buildpiper"
    },
    {
      name                       = "buildpiper_api"
      rule_type                  = "Basic"
      http_listener_name         = "api-buildpiper"
      backend_address_pool_name  = "Buildpiper"
      backend_http_settings_name = "api-buildpiper"
    },
    {
      name                       = "Nexus_cli"
      rule_type                  = "Basic"
      http_listener_name         = "nexuscli"
      backend_address_pool_name  = "Nexus"
      backend_http_settings_name = "nexus-cli"
    },
    {
      name                       = "Nexus_ui"
      rule_type                  = "Basic"
      http_listener_name         = "nexusui"
      backend_address_pool_name  = "Nexus"
      backend_http_settings_name = "nexus-ui"
  }]
}

variable "tag_map" {
  default = {
    Creator = "Mehul Sharma"
  }
}

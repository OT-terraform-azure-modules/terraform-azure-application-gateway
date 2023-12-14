#----------------------------  app gw -------------------------------------------------

variable "agw_name" {
  default = "buildpiper-agwnew"
}

variable "agw_pubip_name" {
  default = "agw-pub-ip"
}

variable "agw_nsg_name" {
  default = "agw-nsg-name"
}

variable "agw_subnet_name" {
  default = "agw_subnet"
}

variable "agw_address_prefix" {
  default = ["192.168.2.0/24"]
}

variable "public_ip_allocation_method" {
  type        = string
  description = "Type of PUBLIC IP will get allocated"
  default     = "Dynamic"
}

variable "pip_sku" {
  type        = string
  description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Basic"
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

variable "backend_address_pool" {
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

variable "waf_configuration" {
  description = "Web Application Firewall support for your Azure Application Gateway"
  type = object({
    firewall_mode            = string
    rule_set_version         = string
    file_upload_limit_mb     = optional(number)
    request_body_check       = optional(bool)
    max_request_body_size_kb = optional(number)
    disabled_rule_group = list(object({
      rule_group_name = string
      rules           = list(string)
    }))
    exclusion = list(object({
      match_variable          = string
      selector_match_operator = string
      selector                = string
    }))
  })
  default = null
}

variable "probes" {
  type = list(object({
    name                                      = string
    protocol                                  = string
    host                                      = string
    path                                      = string
    port                                      = number
    pick_host_name_from_backend_http_settings = bool
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    match_status_code                         = list(string)
  }))
}

variable "redirect_configuration" {
  description = "list of maps for redirect configurations"
  type        = list(map(string))
  default     = []
}

variable "ssl_certificates" {
  description = "List of SSL certificates data for Application gateway"
  type = list(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  default = []
}


variable "tag_map" {
  default = {
    Creator = "Mehul Sharma"
  }
}

variable "use_waf_policy" {
  type        = bool
  description = "(optional) Enable it if want to use waf policy with Appp Gw."
  default     = false
}
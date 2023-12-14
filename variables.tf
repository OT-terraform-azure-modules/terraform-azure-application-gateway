variable "agw_resource_group_name" {
  type        = string
  description = "RG of the subnet"
}

variable "agw_vnet_name" {
  type        = string
  description = "Name of the Vnet"
}

variable "agw_address_prefix" {
  type        = list(string)
  description = "Subnet address space"
}

variable "agw_name" {
  type        = string
  description = "Application Gateway Name"
}

variable "agw_resource_group_location" {
  type        = string
  description = "Application Gateway Location"
}

variable "sku" {
  type        = map(string)
  description = "Map to define the sku of the Application Gateway: Standard(Small, Medium, Large) or WAF (Medium, Large), and the capacity (between 1 and 10)"
}

variable "frontend_port" {
  type        = any
  description = "List of FrontEnd Ports and Names"
}

variable "backend_address_pool" {
  type        = any
  description = "List of Backend Address Pool"
}

variable "backend_http_settings" {
  type        = any
  description = "List of Backend HTTP Settings"
}

variable "http_listener" {
  type        = any
  description = "List of HTTP Listners"
}

variable "request_routing_rule" {
  type        = any
  description = "List of Request Routing Rules"
}

variable "tag_map" {
  type = map(string)
  description = "Map of Tags those we want to Add"
}

variable "public_ip_allocation_method" {
  type = string
  description = "Type of PUBLIC IP will get allocated"
  default = "Dynamic"
}

variable "agw_security_rule" {
  type = list(map(string))
  description = "Please mention the security rules here."
}

variable "pip_sku" {
  type        = string
  description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic."
  default     = "Basic"
}

variable "agw_pubip_name" {
  default = "agw-pub-ip"
}

variable "agw_nsg_name" {
  default = "agw-nsg-name"
}

variable "agw_subnet_name" {
  default = "agw_subnet_name"
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
    name                  = string
    protocol              = string
    host                  = string
    path                  = string
    port                  = number
    pick_host_name_from_backend_http_settings = bool
    interval              = number
    timeout               = number
    unhealthy_threshold   = number
    match_status_code     = list(string)
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

variable "use_waf_policy" {
  type = bool
  description = "(optional) Enable it if want to use waf policy with Appp Gw."
  default = false
}

variable "firewall_policy_id" {
  type = string
  description = "(optional) Provide the Firewal policy id to be use with Application gateway."
}


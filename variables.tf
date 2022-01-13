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

Azure Application Gateway Terraform Module
=====================================

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage]

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

Terraform module which creates Subnet, Network Security Group, Public IP and Application Gateway.

Terraform versions
------------------
Terraform 0.14.9

Usage
------

```hcl
module "agw" {
  source                      = "git::https://github.com/OT-terraform-azure-modules/terraform-azure-application-gateway.git"
  agw_name                    = var.agw_name
  agw_resource_group_name     = var.rg_name
  agw_resource_group_location = var.rg_location
  agw_vnet_name               = var.vnet_name
  request_routing_rule        = var.agw_request_routing_rule
  http_listener               = var.agw_http_listener
  backend_http_settings       = var.agw_backend_http_settings
  backend_address_pool        = var.agw_backend_address_pool
  frontend_port               = var.agw_frontend_port
  sku                         = var.agw_sku
  agw_address_prefix          = var.agw_address_prefix
  agw_security_rule           = var.agw_security_rule
  tag_map = var.tag_map
}
```
**NOTE: You can also refer the variable.tf file under example directory to get the idea on variables define in module.**

Tags
----
* Tags are assigned to resources with name variable as prefix.
* Additial tags can be assigned by tags variables as defined above.


Resources
------
| Name | Type |
|------|------|
| [azurerm_application_gateway.agw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.agw_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group.agw_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_subnet_network_security_group_association.agw_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |


Inputs
------
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| agw_resource_group_name | RG of the subnet | `string` |  | yes |
| agw_vnet_name | Name of the vnet | `string` |  | no |
| agw_address_prefix | The address prefixes to use for the subnet | `list(string)` |  | yes |
| agw_name | Application Gateway name | `string` |  | yes |
| agw_resource_group_location | Location where we want to implement Application Gateway | `string` |  | yes |
| sku | Map to define the sku of the Application Gateway: Standard(Small, Medium, Large) or WAF (Medium, Large), and the capacity (between 1 and 10) | `map(string)` |  | yes |
| frontend_port | List of FrontEnd Ports and Names | `any` |  | yes |
| backend_address_pool | List of Backend Address Pool | `any` |  | yes |
| backend_http_settings | List of Backend HTTP Settings | `any` |  | yes |
| http_listener | List of HTTP Listners | `any` |  | yes |
| request_routing_rule | List of Request Routing Rules | `any` | `` | yes |
| tag_map | Please mention the tags here | `map(string)` |  | no |
| public_ip_allocation_method | Allocation method for the public IP | `string` | `"Dynamic"` | no |
| agw_security_rule | Please mention the security rules here | `string` |  | yes |


Output
------
| Name | Description |
|------|-------------|
| agw_id | ID of the Application Gateway |
| agw_subnet_id | ID of the Subnet created with Application Gateway |
| nsg_id | ID of the Network Security Group created with Application Gateway |


## Related Projects

Check out these related projects.

* [Resource Group](https://gitlab.com/ot-azure/terraform/rg)
* [Virtual Network](https://gitlab.com/ot-azure/terraform/virtual_network)


### Contributor

|  [![Mehul Sharma][mehul_avatar]][mehul_homepage]<br/>[Mehul Sharma][mehul_homepage] |
|---|

  [mehul_homepage]: https://gitlab.com/mehulsharma2010
  [mehul_avatar]: https://gitlab.com/uploads/-/system/user/avatar/7039343/avatar.png?width=300



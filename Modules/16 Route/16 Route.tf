##############################################################
#This module allows the creation of Route 
##############################################################

#Variable declaration for Module

#The Name of the route
variable "RouteName" {
  type = "string"
}

#The RG in which the route table is attached to
variable "RGName" {
  type = "string"
}

#The route table name with which the route is associated to
variable "RTName" {
  type = "string"
}

#The destination CIDR to which the route applies
variable "DestinationCIDR" {
  type = "string"
}

#The type of Azure hop the packet should be sent to. 
#Possible values are VirtualNetworkGateway, VnetLocal, 
#Internet, VirtualAppliance and None
variable "NextHop" {
  type = "string"
}

#Contains the IP address packets should be forwarded to.
#Next hop values are only allowed in routes where the 
#next hop type is VirtualAppliance.
variable "NextHopinIPAddress" {
  type = "string"
}

# Route table creation

resource "azurerm_route" "TerraRoute" {
  name                   = "${var.RouteName}"
  route_table_name       = "${var.RTName}"
  resource_group_name    = "${var.RGName}"
  address_prefix         = "${var.DestinationCIDR}"
  next_hop_type          = "${var.NextHop}"
  next_hop_in_ip_address = "${var.NextHopinIPAddress}"
}

#Output

output "Name" {
  value = "${azurerm_route_table.TerraRoute.name}"
}

output "Id" {
  value = "${azurerm_route_table.TerraRoute.id}"
}

output "RGName" {
  value = "${azurerm_route_table.TerraRoute.resource_group_name}"
}

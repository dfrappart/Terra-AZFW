######################################################################
# This module allows the creation of a Public IP Address
######################################################################

#Module variables

#Public IP Count

variable "PublicIPCount" {
  type    = "string"
  default = "1"
}

#The Public IP Name

variable "PublicIPName" {
  type = "string"
}

#The Public IP Location

variable "PublicIPLocation" {
  type = "string"
}

#The RG in which the Public IP resides

variable "RGName" {
  type = "string"
}

#The IP Address allocation. Can be dynamic or static

variable "PIPAddressAllocation" {
  type    = "string"
  default = "static"
}

#The IP Address sku. Can be basic or standard

variable "PIPAddressSku" {
  type    = "string"
  default = "basic"
}

variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}

# Creating Public IP 
/*
resource "random_string" "PublicIPfqdnprefix" {
  length  = 5
  special = false
  upper   = false
  number  = false
}
*/

resource "azurerm_public_ip" "TerraPublicIP" {
  count                        = "${var.PublicIPCount}"
  name                         = "${var.PublicIPName}${count.index+1}"
  location                     = "${var.PublicIPLocation}"
  resource_group_name          = "${var.RGName}"
  public_ip_address_allocation = "${var.PIPAddressAllocation}"
  sku                          = "${var.PIPAddressSku}"
  domain_name_label            = "${lower(var.EnvironmentTag)}${lower(var.PublicIPName)}${count.index+1}"

  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}

#Module output

output "Names" {
  value = ["${azurerm_public_ip.TerraPublicIP.*.name}"]
}

output "Ids" {
  value = ["${azurerm_public_ip.TerraPublicIP.*.id}"]
}

/*
output "IPAddresses" {

  value = ["${azurerm_public_ip.TerraPublicIP.*.ip_address}"]
}
*/
output "fqdns" {
  value = ["${azurerm_public_ip.TerraPublicIP.*.fqdn}"]
}

output "RGName" {
  value = "${var.RGName}"
}

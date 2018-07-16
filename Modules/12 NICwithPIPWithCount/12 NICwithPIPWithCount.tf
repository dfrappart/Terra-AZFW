##############################################################
#This module allows the creation of VMs NICs
##############################################################

#Variables for NIC creation

#The NIC count
variable "NICCount" {
  type    = "string"
  default = "1"
}

#The NIC name
variable "NICName" {
  type = "string"
}

#The NIC location
variable "NICLocation" {
  type = "string"
}

#The resource Group in which the NIC are attached to
variable "RGName" {
  type = "string"
}

#The subnet reference
variable "SubnetId" {
  type = "string"
}

#The public IP Reference

variable "PublicIPId" {
  type = "list"
}

variable "Primary" {
  type    = "string"
  default = "true"
}

variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}

# NIC Creation 

resource "azurerm_network_interface" "TerraNICwpip" {
  count               = "${var.NICCount}"
  name                = "${var.NICName}${count.index+1}"
  location            = "${var.NICLocation}"
  resource_group_name = "${var.RGName}"

  ip_configuration {
    name                          = "ConfigIP-NIC-${var.NICName}"
    subnet_id                     = "${var.SubnetId}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(var.PublicIPId,count.index)}"
    primary                       = "${var.Primary}"
  }

  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}

output "Names" {
  value = ["${azurerm_network_interface.TerraNICwpip.*.name}"]
}

output "Ids" {
  value = ["${azurerm_network_interface.TerraNICwpip.*.id}"]
}

output "PrivateIPs" {
  value = ["${azurerm_network_interface.TerraNICwpip.*.private_ip_address}"]
}

output "RGName" {
  value = "${var.RGName}"
}

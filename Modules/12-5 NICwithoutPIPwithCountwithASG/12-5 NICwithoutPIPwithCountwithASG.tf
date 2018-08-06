##############################################################
#This module allows the creation of VMs NICs without Public IP
#With ASG
##############################################################

#Variables for NIC creation

#The count value
variable "NICcount" {
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

variable "ASGId" {
  type = "list"
}

#Behind a lb
variable "IsLoadBalanced" {
  type    = "string"
  default = "0"
}

#BackendPool id

variable "LBBackEndPoolid" {
  type    = "list"
  default = ["defaultPool1", "defaultPool1"]
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

resource "azurerm_network_interface" "TerraNICnopipwithcountLoadBalanced" {
  count                         = "${var.IsLoadBalanced ? var.NICcount : 0}"
  name                          = "${var.NICName}${count.index+1}"
  location                      = "${var.NICLocation}"
  resource_group_name           = "${var.RGName}"
  application_security_group_id = "${var.ASGId}"

  ip_configuration {
    name                                    = "ConfigIP-NIC${var.NICName}${count.index+1}"
    subnet_id                               = "${var.SubnetId}"
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = ["${element(var.LBBackEndPoolid,count.index)}"]
  }

  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}

resource "azurerm_network_interface" "TerraNICnopipwithcountNotLoadBalanced" {
  count               = "${var.IsLoadBalanced ? 0 : var.NICcount}"
  name                = "${var.NICName}${count.index+1}"
  location            = "${var.NICLocation}"
  resource_group_name = "${var.RGName}"

  ip_configuration {
    name                          = "ConfigIP-NIC${var.NICName}${count.index+1}"
    subnet_id                     = "${var.SubnetId}"
    private_ip_address_allocation = "dynamic"
    application_security_group_id = ["${var.ASGId}"]
  }

  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}

output "LBNames" {
  value = ["${azurerm_network_interface.TerraNICnopipwithcountLoadBalanced.*.name}"]
}

output "LBIds" {
  value = ["${azurerm_network_interface.TerraNICnopipwithcountLoadBalanced.*.id}"]
}

output "LBPrivateIPs" {
  value = ["${azurerm_network_interface.TerraNICnopipwithcountLoadBalanced.*.private_ip_address}"]
}

output "Names" {
  value = ["${azurerm_network_interface.TerraNICnopipwithcountLoadBalanced.*.name}"]
}

output "Ids" {
  value = ["${azurerm_network_interface.TerraNICnopipwithcountNotLoadBalanced.*.id}"]
}

output "PrivateIPs" {
  value = ["${azurerm_network_interface.TerraNICnopipwithcountNotLoadBalanced.*.private_ip_address}"]
}

output "RGName" {
  value = "${var.RGName}"
}

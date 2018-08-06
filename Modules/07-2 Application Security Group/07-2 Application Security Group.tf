##############################################################
#This module allows the creation of an Application Security 
#Group
##############################################################

#Variable declaration for Module

variable "ASGName" {
  type    = "string"
  default = "DefaultNSG"
}

variable "RGName" {
  type    = "string"
  default = "DefaultRSG"
}

variable "ASGLocation" {
  type    = "string"
  default = "Westeurope"
}

variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}

#Creation fo the ASG
resource "azurerm_application_security_group" "Terra-ASG" {
  name                = "${var.ASGName}"
  location            = "${var.ASGLocation}"
  resource_group_name = "${var.RGName}"

  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}

#Output for the ASG module

output "Name" {
  value = "${azurerm_application_security_group.Terra-ASG.name}"
}

output "Id" {
  value = "${azurerm_application_security_group.Terra-ASG.id}"
}

output "RGName" {
  value = "${azurerm_application_security_group.Terra-ASG.resource_group_name}"
}

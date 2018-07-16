##############################################################
#This module allows the creation of a storage container
##############################################################

#module variables

#The ST container

variable "StorageContainerName" {
  type = "string"
}

#The RG Name

variable "RGName" {
  type = "string"
}

#The Storage Account Name

variable "StorageAccountName" {
  type = "string"
}

#The Storage Account container access type

variable "AccessType" {
  type    = "string"
  default = "private"
}

#Varaibles defining Tags

variable "EnvironmentTag" {
  type    = "string"
  default = "Poc"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Poc usage only"
}

#Storage container creation

resource "azurerm_storage_container" "Terra-STC" {
  name                  = "${var.StorageContainerName}"
  resource_group_name   = "${var.RGName}"
  storage_account_name  = "${var.StorageAccountName}"
  container_access_type = "${var.AccessType}"
}

output "Id" {
  value = "${azurerm_storage_container.Terra-STC.id}"
}

output "Properties" {
  value = "${azurerm_storage_container.Terra-STC.properties}"
}

output "RGName" {
  value = "${azurerm_storage_container.Terra-STC.resource_group_name}"
}

output "Name" {
  value = "${azurerm_storage_container.Terra-STC.name}"
}

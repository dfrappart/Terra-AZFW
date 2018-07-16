####################################################################
#This module allows the creation of a storage sharefile (Azure File)
####################################################################

#module variables

#The Azure File Name

variable "ShareName" {
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

#The Azure File Quota

variable "Quota" {
  type    = "string"
  default = "0"
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

#Storage Share creation

resource azurerm_storage_share "Terra-AzureFile" {
  name                 = "${var.ShareName}"
  resource_group_name  = "${var.RGName}"
  storage_account_name = "${var.StorageAccountName}"
  quota                = "${var.Quota}"
}

output "Id" {
  value = "${azurerm_storage_share.Terra-AzureFile.id}"
}

output "URL" {
  value = "${azurerm_storage_share.Terra-AzureFile.url}"
}

output "RGName" {
  value = "${azurerm_storage_share.Terra-AzureFile.resource_group_name}"
}

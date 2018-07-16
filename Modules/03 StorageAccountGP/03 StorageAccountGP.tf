##############################################################
#This module allows the creation of a storage account
##############################################################

#module variables

#The ST Name

variable "StorageAccountName" {
  type = "string"
}

#The RG Name

variable "RGName" {
  type = "string"
}

#The Storage Account Location

variable "StorageAccountLocation" {
  type = "string"
}

#The Storage Account Tier

variable "StorageAccountTier" {
  type    = "string"
  default = "Standard"
}

#The Storage Account Replication Type, accept LRS, GRS, RAGRS and ZRS.

variable "StorageReplicationType" {
  type    = "string"
  default = "LRS"
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

#Storage account creation

resource "azurerm_storage_account" "Terra-STOA" {
  name                     = "stoa${lower(var.StorageAccountName)}"
  resource_group_name      = "${var.RGName}"
  location                 = "${var.StorageAccountLocation}"
  account_tier             = "${var.StorageAccountTier}"
  account_replication_type = "${var.StorageReplicationType}"
  account_kind             = "StorageV2"

  tags {
    environment            = "${var.EnvironmentTag}"
    usage                  = "${var.EnvironmentUsageTag}"
    StorageReplicationType = "${var.StorageReplicationType}"
    StorageAccountTier     = "${var.StorageAccountTier}"
  }
}

#Output for the module

output "Name" {
  value = "${azurerm_storage_account.Terra-STOA.name}"
}

output "Id" {
  value = "${azurerm_storage_account.Terra-STOA.id}"
}

output "PrimaryBlobEP" {
  value = "${azurerm_storage_account.Terra-STOA.primary_blob_endpoint}"
}

output "PrimaryQueueEP" {
  value = "${azurerm_storage_account.Terra-STOA.primary_queue_endpoint}"
}

output "PrimaryTableEP" {
  value = "${azurerm_storage_account.Terra-STOA.primary_table_endpoint}"
}

output "PrimaryFileEP" {
  value = "${azurerm_storage_account.Terra-STOA.primary_file_endpoint}"
}

output "PrimaryAccessKey" {
  value = "${azurerm_storage_account.Terra-STOA.primary_access_key}"
}

output "SecondaryAccessKey" {
  value = "${azurerm_storage_account.Terra-STOA.secondary_access_key}"
}

output "ConnectionURI" {
  value = "${azurerm_storage_account.Terra-STOA.primary_blob_connection_string}"
}

output "RGName" {
  value = "${azurerm_storage_account.Terra-STOA.resource_group_name}"
}

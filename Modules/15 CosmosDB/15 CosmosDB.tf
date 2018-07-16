######################################################################
# This module create a cosmosdb account
######################################################################

#Module variables

variable "CosmosDBName" {
  default = "TerraCosmosDB"
}

variable "CosmosDBLocation" {}

variable "CosmosDBRG" {}

variable "CosmosDBOffer" {
  default = "standard"
}

variable "CosmosDBKind" {
  default = "GlobalDocumentDB"
}

variable "CosmosDBFailoverConf" {
  default = "true"
}

variable "CosmosDBConsistencyLevel" {
  default = "BoundedStaleness"
}

variable "CosmosDBMaxInterval" {
  default = "5"
}

variable "CosmosDBMaxStaleness" {
  default = "100"
}

variable "CosmosDBPRimaryLocation" {
  default = "westeurope"
}

variable "CosmosDBSecondaryLocation" {
  default = "northeurope"
}

#Module resources

resource "azurerm_cosmosdb_account" "TerraCosmosDB" {
  name                      = "${var.CosmosDBName}"
  location                  = "${var.CosmosDBLocation}"
  resource_group_name       = "${var.CosmosDBRG}"
  offer_type                = "${var.CosmosDBOffer}"
  kind                      = "${var.CosmosDBKind}"
  enable_automatic_failover = "${var.CosmosDBFailoverConf}"

  consistency_policy {
    consistency_level       = "${var.CosmosDBConsistencyLevel}"
    max_interval_in_seconds = "${var.CosmosDBMaxInterval}"
    max_staleness_prefix    = "${var.CosmosDBMaxStaleness}"
  }

  geo_location {
    location          = "${var.CosmosDBPRimaryLocation}"
    failover_priority = "0"
  }

  geo_location {
    location          = "${var.CosmosDBSecondaryLocation}"
    failover_priority = "1"
  }
}

#Module Output

output "Id" {
  value = "${azurerm_cosmosdb_account.TerraCosmosDB.id}"
}

output "EP" {
  value = "${azurerm_cosmosdb_account.TerraCosmosDB.endpoint}"
}

output "REP" {
  value = "${azurerm_cosmosdb_account.TerraCosmosDB.read_endpoints}"
}

output "WEP" {
  value = "${azurerm_cosmosdb_account.TerraCosmosDB.write_endpoints}"
}

output "PMK" {
  value     = "${azurerm_cosmosdb_account.TerraCosmosDB.primary_master_key}"
  sensitive = true
}

output "SMK" {
  value     = "${azurerm_cosmosdb_account.TerraCosmosDB.secondary_master_key}"
  sensitive = true
}

output "PRMK" {
  value     = "${azurerm_cosmosdb_account.TerraCosmosDB.primary_readonly_master_key}"
  sensitive = true
}

output "SRMK" {
  value     = "${azurerm_cosmosdb_account.TerraCosmosDB.secondary_readonly_master_key}"
  sensitive = true
}

output "CSTR" {
  value = "${azurerm_cosmosdb_account.TerraCosmosDB.connection_strings}"
}

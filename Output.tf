######################################################
# This file defines which value are sent to output
######################################################

######################################################
# Resource group info Output

output "ResourceGroupInfraName" {
  value = "${module.ResourceGroupInfra.Name}"
}

output "ResourceGroupInfraId" {
  value = "${module.ResourceGroupInfra.Id}"
}

######################################################
# vNet info Output

output "vNet1Name" {
  value = "${module.VNet1.Name}"
}

output "vNet1Id" {
  value = "${module.VNet1.Id}"
}

output "vNet1AddressSpace" {
  value = "${module.VNet1.AddressSpace}"
}

output "vNet2Name" {
  value = "${module.VNet2.Name}"
}

output "vNet2Id" {
  value = "${module.VNet2.Id}"
}

output "vNet2AddressSpace" {
  value = "${module.VNet2.AddressSpace}"
}

######################################################
# Diag & Log Storage account Info

output "DiagStorageAccountName" {
  value = "${module.DiagStorageAccount.Name}"
}

output "DiagStorageAccountID" {
  value = "${module.DiagStorageAccount.Id}"
}

output "DiagStorageAccountPrimaryBlobEP" {
  value = "${module.DiagStorageAccount.PrimaryBlobEP}"
}

output "DiagStorageAccountPrimaryQueueEP" {
  value = "${module.DiagStorageAccount.PrimaryQueueEP}"
}

output "DiagStorageAccountPrimaryTableEP" {
  value = "${module.DiagStorageAccount.PrimaryTableEP}"
}

output "DiagStorageAccountPrimaryFileEP" {
  value = "${module.DiagStorageAccount.PrimaryFileEP}"
}

output "DiagStorageAccountPrimaryAccessKey" {
  value = "${module.DiagStorageAccount.PrimaryAccessKey}"
}

output "DiagStorageAccountSecondaryAccessKey" {
  value = "${module.DiagStorageAccount.SecondaryAccessKey}"
}

######################################################
# Files Storage account Info

output "FilesExchangeStorageAccountName" {
  value = "${module.FilesExchangeStorageAccount.Name}"
}

output "FilesExchangeStorageAccountID" {
  value = "${module.FilesExchangeStorageAccount.Id}"
}

output "FilesExchangeStorageAccountPrimaryBlobEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryBlobEP}"
}

output "FilesExchangeStorageAccountPrimaryQueueEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryQueueEP}"
}

output "FilesExchangeStorageAccountPrimaryTableEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryTableEP}"
}

output "FilesExchangeStorageAccountPrimaryFileEP" {
  value = "${module.FilesExchangeStorageAccount.PrimaryFileEP}"
}

output "FilesExchangeStorageAccountPrimaryAccessKey" {
  value = "${module.FilesExchangeStorageAccount.PrimaryAccessKey}"
}

output "FilesExchangeStorageAccountSecondaryAccessKey" {
  value = "${module.FilesExchangeStorageAccount.SecondaryAccessKey}"
}

######################################################
# Subnet info Output
######################################################

######################################################
#FE_Subnet

output "FE_Subnet_VNet2Name" {
  value = "${module.FE_Subnet_VNet2.Name}"
}

output "FE_Subnet_VNet2Id" {
  value = "${module.FE_Subnet_VNet2.Id}"
}

output "FE_Subnet_VNet2AddressPrefix" {
  value = "${module.FE_Subnet_VNet2.AddressPrefix}"
}


######################################################
#BE_Subnet

output "BE_Subnet_VNet2Name" {
  value = "${module.BE_Subnet_VNet2.Name}"
}

output "BE_Subnet_VNet2Id" {
  value = "${module.BE_Subnet_VNet2.Id}"
}

output "BE_Subnet_VNet2AddressPrefix" {
  value = "${module.BE_Subnet_VNet2.AddressPrefix}"
}



######################################################
#Bastion_Subnet

output "Bastion_Subnet_VNet2Name" {
  value = "${module.Bastion_Subnet_VNet2.Name}"
}

output "Bastion_Subnet_VNet2Id" {
  value = "${module.Bastion_Subnet_VNet2.Id}"
}

output "Bastion_Subnet_VNet2AddressPrefix" {
  value = "${module.Bastion_Subnet_VNet2.AddressPrefix}"
}


######################################################
#AZFW_Subnet

output "FW_Subnet_VNet2Name" {
  value = "${module.FW_Subnet_VNet2.Name}"
}

output "FW_Subnet_VNet2Id" {
  value = "${module.FW_Subnet_VNet2.Id}"
}

output "FW_Subnet_VNet2AddressPrefix" {
  value = "${module.FW_Subnet_VNet2.AddressPrefix}"
}


######################################################
#AZGW_Subnet

output "GW_Subnet_VNet2Name" {
  value = "${module.GW_Subnet_VNet2.Name}"
}

output "GW_Subnet_VNet2Id" {
  value = "${module.GW_Subnet_VNet2.Id}"
}

output "GW_Subnet_VNet2AddressPrefix" {
  value = "${module.GW_Subnet_VNet2.AddressPrefix}"
}

######################################################
#Bastion VNet1 VMs Output

output "BastionVNet1fqdn" {
  value = ["${module.BastionVNet1PublicIP.fqdns}"]
}

output "BastionVNet1PrivateIP" {
  value = ["${module.NICs_Bastion_VNet1.PrivateIPs}"]
}

output "BastionVNet1NICId" {
  value = ["${module.NICs_Bastion_VNet1.Ids}"]
}

######################################################
#Bastion VNet2 VMs Output

output "BastionVNet2fqdn" {
  value = ["${module.BastionVNet2PublicIP.fqdns}"]
}

output "BastionVNet2PrivateIP" {
  value = ["${module.NICs_Bastion_VNet2.PrivateIPs}"]
}

output "BastionVNet2NICId" {
  value = ["${module.NICs_Bastion_VNet2.Ids}"]
}

######################################################
# Subnet info Output
######################################################

######################################################
#FE_Subnet

output "FE_Subnet_VNet1Name" {
  value = "${module.FE_Subnet_VNet1.Name}"
}

output "FE_Subnet_VNet1Id" {
  value = "${module.FE_Subnet_VNet1.Id}"
}

output "FE_Subnet_VNet1AddressPrefix" {
  value = "${module.FE_Subnet_VNet1.AddressPrefix}"
}


######################################################
#BE_Subnet

output "BE_Subnet_VNet1Name" {
  value = "${module.BE_Subnet_VNet1.Name}"
}

output "BE_Subnet_VNet1Id" {
  value = "${module.BE_Subnet_VNet1.Id}"
}

output "BE_Subnet_VNet1AddressPrefix" {
  value = "${module.BE_Subnet_VNet1.AddressPrefix}"
}



######################################################
#Bastion_Subnet

output "Bastion_Subnet_VNet1Name" {
  value = "${module.Bastion_Subnet_VNet1.Name}"
}

output "Bastion_Subnet_VNet1Id" {
  value = "${module.Bastion_Subnet_VNet1.Id}"
}

output "Bastion_Subnet_VNet1AddressPrefix" {
  value = "${module.Bastion_Subnet_VNet1.AddressPrefix}"
}


######################################################
#AZFW_Subnet

output "FW_Subnet_VNet1Name" {
  value = "${module.FW_Subnet_VNet1.Name}"
}

output "FW_Subnet_VNet1Id" {
  value = "${module.FW_Subnet_VNet1.Id}"
}

output "FW_Subnet_VNet1AddressPrefix" {
  value = "${module.FW_Subnet_VNet1.AddressPrefix}"
}


######################################################
#AZGW_Subnet

output "GW_Subnet_VNet1Name" {
  value = "${module.GW_Subnet_VNet1.Name}"
}

output "GW_Subnet_VNet1Id" {
  value = "${module.GW_Subnet_VNet1.Id}"
}

output "GW_SubnetAddressPrefix" {
  value = "${module.GW_Subnet_VNet1.AddressPrefix}"
}

######################################################
#AZ FW output

output "AZFW_VNet2IPConfig" {
  value = "${module.FW_VNet2.IPConfig}"
}

output "AZFW_VNet2Id" {
  value = "${module.FW_VNet2.Id}"
}

output "AZFW_VNet2Name" {
  value = "${module.FW_VNet2.Name}"
}
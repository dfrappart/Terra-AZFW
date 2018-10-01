######################################################
# This file deploys the subnet and NSG for 
#Basic linux architecture Architecture
######################################################

######################################################################
# Subnet and NSG
######################################################################

######################################################################
# Bastion zone
######################################################################

#Bastion_Subnet NSG

module "NSG_Bastion_Subnet_VNet2" {
  #Module location
  source = "./Modules/07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 2)}_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Bastion_Subnet

module "Bastion_Subnet_VNet2" {
  #Module location
  source = "./Modules/06-1 Subnet"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 2)}_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 7)}"
  NSGid               = "${module.NSG_Bastion_Subnet_VNet2.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

######################################################################
# FE zone
######################################################################

#FE_Subnet NSG

module "NSG_FE_Subnet_VNet2" {
  #Module location
  source = "./Modules/07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 0)}_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#FE_Subnet1

module "FE_Subnet_VNet2" {
  #Module location
  source = "./Modules/06-3 Subnet with routetable"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 0)}_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 5)}"
  NSGid               = "${module.NSG_FE_Subnet_VNet2.Id}"
  RouteTableId        = "${module.RouteTable.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}



######################################################################
# BE zone
######################################################################

#BE_Subnet NSG

module "NSG_BE_Subnet_VNet2" {
  #Module location
  source = "./Modules/07 NSG"

  #Module variable
  NSGName             = "NSG_BE_Subnet_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#BE_Subnet1

module "BE_Subnet_VNet2" {
  #Module location
  source = "./Modules/06-3 Subnet with routetable"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 2)}_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 6)}"
  NSGid               = "${module.NSG_BE_Subnet_VNet2.Id}"
  RouteTableId        = "${module.RouteTable.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}



######################################################################
# GW Subnet zone
######################################################################

#FW_Subnet

module "GW_Subnet_VNet2" {
  #Module location
  source = "./Modules/06-2 SubnetWithoutNSG"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 4)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 9)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

######################################################################
# Application Security Groups
######################################################################

#ASG for MSSQL Servers
module "ASG_MSsqlServers_VNet2" {
  #Module location
  source = "./Modules/07-2 Application Security Group"

  #Module variables
  ASGName             = "MSsqlServers_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ASGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#ASG for IIS Server

module "ASG_IISServers_VNet2" {
  #Module location
  source = "./Modules/07-2 Application Security Group"

  #Module variables
  ASGName             = "IISServers_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ASGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

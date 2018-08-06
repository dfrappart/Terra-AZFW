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

module "NSG_Bastion_Subnet" {
  #Module location
  source = "./Modules/07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 2)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Bastion_Subnet

module "Bastion_Subnet" {
  #Module location
  source = "./Modules/06 - 1 Subnet"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 2)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 2)}"
  NSGid               = "${module.NSG_Bastion_Subnet.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

######################################################################
# FE zone
######################################################################

#FE_Subnet NSG

module "NSG_FE_Subnet" {
  #Module location
  source = "./Modules/07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 0)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#FE_Subnet

module "FE_Subnet" {
  #Module location
  source = "./Modules/06 - 3 Subnet with routetable"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 0)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 0)}"
  NSGid               = "${module.NSG_FE_Subnet.Id}"
  RouteTableId        = "${module.RouteTable.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

######################################################################
# BE zone
######################################################################

#BE_Subnet NSG

module "NSG_BE_Subnet" {
  #Module location
  source = "./Modules/07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 1)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#FE_Subnet

module "BE_Subnet" {
  #Module location
  source = "./Modules/06 - 1 Subnet"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 1)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 1)}"
  NSGid               = "${module.NSG_BE_Subnet.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

######################################################################
# Application Security Groups
######################################################################

#ASG for PotGresql Servers
module "ASG_PostGresqlServer" {
  #Module location
  source = "./Modules/07-2 Application Security Group"

  #Module variables
  ASGName             = "PostGresqlServer"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ASGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#ASG for IIS Server

module "ASG_IISServers" {
  #Module location
  source = "./Modules/07-2 Application Security Group"

  #Module variables
  ASGName             = "IISServers"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ASGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

######################################################################
# Creation Azure FW
######################################################################

######################################################################
# FW Subnet zone
######################################################################

#FW_Subnet

module "FW_Subnet_VNet2" {
  #Module location
  source = "./Modules/06-2 SubnetWithoutNSG"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 3)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 8)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#UDR for AZ FW

module "RouteTable_Vnet2" {
  #Module location
  source = "./Modules/17 RouteTable"

  #Module variable
  RouteTableName      = "RouteTabletoAzFW_Vnet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  RTLocation          = "${var.AzureRegion}"
  BGPDisabled         = "false"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "Route_Vnet2" {
  #Module location
  source = "./Modules/16 Route"

  #Module variable
  RouteName          = "RoutetoAzFW_Vnet2"
  RGName             = "${module.ResourceGroupInfra.Name}"
  RTName             = "${module.RouteTable.Name}"
  DestinationCIDR    = "0.0.0.0/0"
  NextHop            = "VirtualAppliance"
  NextHopinIPAddress = "${cidrhost(var.SubnetAddressRange[8],4)}"
}

#FW PIP

module "FW_Vnet2_PIP" {
  #Module location
  source = "./Modules/10 PublicIP"

  #Module variables
  PublicIPName        = "azurefwvnet2pip"
  PublicIPLocation    = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  PIPAddressSku       = "standard"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}



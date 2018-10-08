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
  vNetName            = "${module.VNet2.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 8)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#UDR for AZ FW

module "RouteTable_VNet2" {
  #Module location
  source = "./Modules/17 RouteTable"

  #Module variable
  RouteTableName      = "RouteTabletoAzFW_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  RTLocation          = "${var.AzureRegion}"
  BGPDisabled         = "false"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "Route_VNet2" {
  #Module location
  source = "./Modules/16 Route"

  #Module variable
  RouteName          = "RoutetoAzFW_Vnet2"
  RGName             = "${module.ResourceGroupInfra.Name}"
  RTName             = "${module.RouteTable_VNet2.Name}"
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

#FW Creation

module "FW_VNet2" {

  #Module location
  source = "./Modules/18 AzureRMFW"

  #Module variables
  FWName              = "AZFWPocVNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  FWLocation          = "${var.AzureRegion}"
  FWSubnetId          = "${module.FW_Subnet_VNet2.Id}"
  FWPIPId             = "${element(module.FW_Vnet2_PIP.Ids,0)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#FW Rule collection 

module "FW_VNet2_CollectionRule1" {

  #Module location
  source = "./Modules/19 AzureRM FW Collection Rules"

  #Module variables
  FWRuleCollecName              = "AZFWPocVNet2RulesCollec1"
  RGName                        = "${module.ResourceGroupInfra.Name}"
  FWName                        = "${module.FW_VNet2.Name}"
  FWRuleCollecAction            = "Allow"
  FWRuleName                    = "TestRule"
  FWRuleDesc                    = "Terraform created rule"
  FWRuleCollecSourceAddresses   = ["${module.BE_Subnet_VNet2.AddressPrefix}"]
  FWRuleCollecDestPorts         = ["80","443","53"]
  FWRuleCollecDestAddresses     = ["0.0.0.0/0"]


}
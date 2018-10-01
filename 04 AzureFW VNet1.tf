######################################################################
# Creation Azure FW
######################################################################

######################################################################
# FW Subnet zone
######################################################################

#FW_Subnet

module "FW_Subnet_VNet1" {
  #Module location
  source = "./Modules/06-2 SubnetWithoutNSG"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 3)}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  vNetName            = "${module.SampleArchi_vNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 3)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#UDR for AZ FW

module "RouteTable_VNet1" {
  #Module location
  source = "./Modules/17 RouteTable"

  #Module variable
  RouteTableName      = "RouteTabletoAzFW_VNet1"
  RGName              = "${module.ResourceGroupInfra.Name}"
  RTLocation          = "${var.AzureRegion}"
  BGPDisabled         = "false"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "Route_Vnet1" {
  #Module location
  source = "./Modules/16 Route"

  #Module variable
  RouteName          = "RoutetoAzFW_Vnet1"
  RGName             = "${module.ResourceGroupInfra.Name}"
  RTName             = "${module.RouteTable.Name}"
  DestinationCIDR    = "0.0.0.0/0"
  NextHop            = "VirtualAppliance"
  NextHopinIPAddress = "${cidrhost(var.SubnetAddressRange[3],4)}"
}

#FW PIP

module "FW_VNet1_PIP" {
  #Module location
  source = "./Modules/10 PublicIP"

  #Module variables
  PublicIPName        = "azurefwvnet1pip"
  PublicIPLocation    = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  PIPAddressSku       = "standard"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

data "template_file" "templateAZFW" {
  template = "${file("./Templates/templateazfw.json")}"
}

resource "azurerm_template_deployment" "Template-AZFW" {
  name                = "azurefwtemplate"
  resource_group_name = "${module.ResourceGroupInfra.Name}"

  template_body = "${data.template_file.templateAZFW.rendered}"

  parameters {
    "location"       = "${var.AzureRegion}"
    "aZFWSubnetId"   = "${module.FW_Subnet_VNet1.Id}"
    "aZFWPublicIpId" = "${element(module.FW_VNet1_PIP.Ids,0)}"
    "bESubnetRange"  = "${lookup(var.SubnetAddressRange, 1)}"
  }

  deployment_mode = "Incremental"
}

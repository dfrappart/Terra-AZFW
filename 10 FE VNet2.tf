##############################################################
#This file creates FE Windows servers
##############################################################

#NSG Rules

module "AllowHTTP-HTTPSFromInternetFEVNet2In" {
  #Module source
  source = "./Modules/08-1 NSGRule"

  #Module variable
  RGName                            = "${module.ResourceGroupInfra.Name}"
  NSGReference                      = "${module.NSG_FE_Subnet_VNet2.Name}"
  NSGRuleName                       = "AllowHTTP-HTTPSFromInternetFEVNet2In"
  NSGRulePriority                   = 101
  NSGRuleDirection                  = "Inbound"
  NSGRuleAccess                     = "Allow"
  NSGRuleProtocol                   = "Tcp"
  NSGRuleDestinationPortRanges       = [80,443]
  NSGRuleSourceAddressPrefixes      = ["0.0.0.0/0"]
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.SubnetAddressRange, 5)}"]
}


module "Allow8080FromInternettoIISServersVNet1In" {
  #Module source
  source = "./Modules/08-3 NSGRule with Dest ASG"

  #Module variable
  RGName                      = "${module.ResourceGroupInfra.Name}"
  NSGReference                = "${module.NSG_FE_Subnet_VNet2.Name}"
  NSGRuleName                 = "Allow8080FromInternettoIISServersVNet1In"
  NSGRulePriority             = 103
  NSGRuleDirection            = "Inbound"
  NSGRuleAccess               = "Allow"
  NSGRuleProtocol             = "Tcp"
  NSGRuleDestinationPortRange = 8080
  NSGRuleSourceAddressPrefix  = "Internet"
  NSGRuleDestinationASG       = ["${module.ASG_IISServers_VNet2.Id}"]
}


#Availability set creation

module "AS_FE_VNet2" {
  #Module source

  source = "./Modules/13 AvailabilitySet"

  #Module variables
  ASName              = "AS_FE_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ASLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#FE public IP Creation

module "FEVNet2PublicIP" {
  #Module source
  source = "./Modules/10 PublicIP"

  #Module variables
  PublicIPCount       = "2"
  PublicIPName        = "fevnet2pip"
  PublicIPLocation    = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_FE_VNet2" {
  #module source

  source = "./Modules/12-6 NICwithPIPwithCountwithASG"

  #Module variables

  NICCount            = "2"
  NICName             = "NIC_FE_VNet2"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  SubnetId            = "${module.FE_Subnet_VNet2.Id}"
  PublicIPId          = ["${module.FEVNet2PublicIP.Ids}"]
  ASGIds              = ["${module.ASG_IISServers_VNet2.Id}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_FE_VNet2" {
  #Module source

  source = "./Modules/11 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "2"
  ManageddiskName     = "DataDisk_FE_VNet2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ManagedDiskLocation = "${var.AzureRegion}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_FE_VNet2" {
  #module source

  source = "./Modules/15 WinVMWithCount"

  #Module variables

  VMCount             = "2"
  VMName              = "FE2"
  VMLocation          = "${var.AzureRegion}"
  VMRG                = "${module.ResourceGroupInfra.Name}"
  VMNICid             = ["${module.NICs_FE_VNet2.Ids}"]
  VMSize              = "${lookup(var.VMSize, 1)}"
  ASID                = "${module.AS_FE_VNet2.Id}"
  VMStorageTier       = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName         = "${var.VMAdminName}"
  VMAdminPassword     = "${var.VMAdminPassword}"
  DataDiskId          = ["${module.DataDisks_FE_VNet2.Ids}"]
  DataDiskName        = ["${module.DataDisks_FE_VNet2.Names}"]
  DataDiskSize        = ["${module.DataDisks_FE_VNet2.Sizes}"]
  VMPublisherName     = "${lookup(var.PublisherName, 0)}"
  VMOffer             = "${lookup(var.Offer, 0)}"
  VMsku               = "${lookup(var.sku, 0)}"
  DiagnosticDiskURI   = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath = "./Scripts/IISinstall.ps1"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "CustomExtensionWinForFE_VNet2" {
  #Module location
  source = "./Modules/22 CustomExtensionScriptwithtpl"

  #Module variables

  AgentCount           = "2"
  AgentName            = "CustomExtensionWinForFE_VNet2"
  AgentLocation        = "${var.AzureRegion}"
  AgentRG              = "${module.ResourceGroupInfra.Name}"
  VMName               = ["${module.VMs_FE_VNet2.Name}"]
  EnvironmentTag       = "${var.EnvironmentTag}"
  EnvironmentUsageTag  = "${var.EnvironmentUsageTag}"
  AgentPublisher       = "microsoft.compute"
  AgentType            = "customscriptextension"
  Agentversion         = "1.9"
  SettingsTemplatePath = "./Templates/CloudInitWin.tpl"
}

module "NetworkWatcherAgentForFEVNet2" {
  #Module Location
  source = "./Modules/21 NetworkwatcheragentWin"

  #Module variables
  AgentCount          = "2"
  AgentName           = "NetworkWatcherAgentForFEVNet2"
  AgentLocation       = "${var.AzureRegion}"
  AgentRG             = "${module.ResourceGroupInfra.Name}"
  VMName              = ["${module.VMs_FE_VNet2.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

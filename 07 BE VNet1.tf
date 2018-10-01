##############################################################
#This file creates BE Windows servers behind the AZ FW
##############################################################

#NSG Rules

module "AllowMSSQLFromASGIIStoASGMSsqlServersVNet1In" {
  #Module source
  source = "./Modules/08-4 NSGRule with source and dest ASG"

  #Module variable
  RGName                      = "${module.ResourceGroupInfra.Name}"
  NSGReference                = "${module.NSG_BE_Subnet_VNet1.Name}"
  NSGRuleName                 = "AllowMSSQLFromASGIIStoASGMSsqlServersVNet1In"
  NSGRulePriority             = 101
  NSGRuleDirection            = "Inbound"
  NSGRuleAccess               = "Allow"
  NSGRuleProtocol             = "Tcp"
  NSGRuleSourcePortRange      = "*"
  NSGRuleDestinationPortRange = 1433
  NSGRuleSourceASG            = ["${module.ASG_IISServers_VNet1.Id}"]
  NSGRuleDestinationASG       = ["${module.ASG_MSsqlServers_VNet1.Id}"]
}

#Availability set creation

module "AS_BE_VNet1" {
  #Module source

  source = "./Modules/13 AvailabilitySet"

  #Module variables
  ASName              = "AS_BE_VNet1"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ASLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_BE_VNet1" {
  #module source

  source = "./Modules/12-5 NICwithoutPIPwithCountwithASG"

  #Module variables

  NICcount            = "2"
  NICName             = "NIC_BE_VNet1"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  SubnetId            = "${module.BE_Subnet_VNet1.Id}"
  ASGIds              = ["${module.ASG_MSsqlServers.Id}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_BE_VNet1" {
  #Module source

  source = "./Modules/11 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "2"
  ManageddiskName     = "DataDisk_BE_VNet1"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ManagedDiskLocation = "${var.AzureRegion}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_BE_VNet1" {
  #module source

  source = "./Modules/15 WinVMWithCount"

  #Module variables

  VMCount             = "2"
  VMName              = "BE_VNet1"
  VMLocation          = "${var.AzureRegion}"
  VMRG                = "${module.ResourceGroupInfra.Name}"
  VMNICid             = ["${module.NICs_BE1.Ids}"]
  VMSize              = "${lookup(var.VMSize, 2)}"
  ASID                = "${module.AS_BE.Id}"
  VMStorageTier       = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName         = "${var.VMAdminName}"
  VMAdminPassword     = "${var.VMAdminPassword}"
  DataDiskId          = ["${module.DataDisks_BE_VNet1.Ids}"]
  DataDiskName        = ["${module.DataDisks_BE_VNet1.Names}"]
  DataDiskSize        = ["${module.DataDisks_BE_VNet1.Sizes}"]
  VMPublisherName     = "${lookup(var.PublisherName, 6)}"
  VMOffer             = "${lookup(var.Offer, 6)}"
  VMsku               = "${lookup(var.sku, 6)}"
  DiagnosticDiskURI   = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath = "./Scripts/IISinstall.ps1"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "CustomExtensionWinForBE_VNet1" {
  #Module location
  source = "./Modules/22 CustomExtensionScriptwithtpl"

  #Module variables

  AgentCount           = "2"
  AgentName            = "CustomExtensionWinForBE_VNet1"
  AgentLocation        = "${var.AzureRegion}"
  AgentRG              = "${module.ResourceGroupInfra.Name}"
  VMName               = ["${module.VMs_BE_VNet1.Name}"]
  EnvironmentTag       = "${var.EnvironmentTag}"
  EnvironmentUsageTag  = "${var.EnvironmentUsageTag}"
  AgentPublisher       = "microsoft.compute"
  AgentType            = "customscriptextension"
  Agentversion         = "1.9"
  SettingsTemplatePath = "./Templates/CloudInitWin.tpl"
}

module "NetworkWatcherAgentForBE_VNet1" {
  #Module Location
  source = "./Modules/21 NetworkwatcheragentWin"

  #Module variables
  AgentCount          = "2"
  AgentName           = "NetworkWatcherAgentForBE_VNet1"
  AgentLocation       = "${var.AzureRegion}"
  AgentRG             = "${module.ResourceGroupInfra.Name}"
  VMName              = ["${module.VMs_BE_VNet1.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

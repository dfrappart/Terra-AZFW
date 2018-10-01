##############################################################
#This file creates Bastion Windows servers
##############################################################

#NSG Rules

module "AllowRDPromInternetBastionVNet1In" {
  #Module source
  source = "./Modules/08-2 NSGRule with services tags"

  #Module variable
  RGName                          = "${module.ResourceGroupInfra.Name}"
  NSGReference                    = "${module.NSG_Bastion_Subnet_VNet1.Name}"
  NSGRuleName                     = "AllowRDPromInternetBastionVNet1In"
  NSGRulePriority                 = 101
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "Tcp"
  NSGRuleSourcePortRange          = "*"
  NSGRuleDestinationPortRange     = 3389
  NSGRuleSourceAddressPrefix      = "Internet"
  NSGRuleDestinationAddressPrefix = "${lookup(var.SubnetAddressRange, 2)}"
}

#Bastion public IP Creation

module "BastionVNet1PublicIP" {
  #Module source
  source = "./Modules/10 PublicIP"

  #Module variables
  PublicIPName        = "bastionvnet1pip"
  PublicIPLocation    = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Availability set creation

module "AS_Bastion_VNet1" {
  #Module source

  source = "./Modules/13 AvailabilitySet"

  #Module variables
  ASName              = "AS_Bastion_VNet1"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ASLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_Bastion_VNet1" {
  #module source

  source = "./Modules/12-1 NICwithPIPWithCount"

  #Module variables

  NICName             = "NIC_Bastion_VNet1"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  SubnetId            = "${module.Bastion_Subnet_VNet1.Id}"
  PublicIPId          = ["${module.BastionVNet1PublicIP.Ids}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_Bastion_VNet1" {
  #Module source

  source = "./Modules/11 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_Bastion_VNet1"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ManagedDiskLocation = "${var.AzureRegion}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_Bastion_VNet1" {
  #module source

  source = "./Modules/15 WinVMWithCount"

  #Module variables

  VMName              = "Bastion_VNet1"
  VMLocation          = "${var.AzureRegion}"
  VMRG                = "${module.ResourceGroupInfra.Name}"
  VMNICid             = ["${module.NICs_Bastion_VNet1.Ids}"]
  VMSize              = "${lookup(var.VMSize, 1)}"
  ASID                = "${module.AS_Bastion.Id}"
  VMStorageTier       = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName         = "${var.VMAdminName}"
  VMAdminPassword     = "${var.VMAdminPassword}"
  DataDiskId          = ["${module.DataDisks_Bastion_VNet1.Ids}"]
  DataDiskName        = ["${module.DataDisks_Bastion_VNet1.Names}"]
  DataDiskSize        = ["${module.DataDisks_Bastion_VNet1.Sizes}"]
  VMPublisherName     = "${lookup(var.PublisherName, 0)}"
  VMOffer             = "${lookup(var.Offer, 0)}"
  VMsku               = "${lookup(var.sku, 0)}"
  DiagnosticDiskURI   = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath = "./Scripts/telnetclientinstall.ps1"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "CustomExtensionWinForBastion_VNet1" {
  #Module location
  source = "./Modules/22 CustomExtensionScriptwithtpl"

  #Module variables

  AgentName            = "CustomExtensionWinForBastion_VNet1"
  AgentLocation        = "${var.AzureRegion}"
  AgentRG              = "${module.ResourceGroupInfra.Name}"
  VMName               = ["${module.VMs_Bastion_VNet1.Name}"]
  EnvironmentTag       = "${var.EnvironmentTag}"
  EnvironmentUsageTag  = "${var.EnvironmentUsageTag}"
  AgentPublisher       = "microsoft.compute"
  AgentType            = "customscriptextension"
  Agentversion         = "1.9"
  SettingsTemplatePath = "./Templates/CloudInitWin.tpl"
}

module "NetworkWatcherAgentForBastion_VNet1" {
  #Module Location
  source = "./Modules/21 NetworkwatcheragentWin"

  #Module variables
  AgentCount          = "1"
  AgentName           = "NetworkWatcherAgentForBastion_VNet1"
  AgentLocation       = "${var.AzureRegion}"
  AgentRG             = "${module.ResourceGroupInfra.Name}"
  VMName              = ["${module.VMs_Bastion_VNet1.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

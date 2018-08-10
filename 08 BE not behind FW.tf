##############################################################
#This file creates BE Windows servers not behind the AZ FW
##############################################################

#NIC Creation

module "NICs_BE2" {
  #module source

  source = "./Modules/12-5 NICwithoutPIPwithCountwithASG"

  #Module variables

  NICName             = "NIC_BE2"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroupInfra.Name}"
  SubnetId            = "${module.BE_Subnet1.Id}"
  ASGIds              = ["${module.ASG_MSsqlServer.Id}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_BE2" {
  #Module source

  source = "./Modules/11 ManagedDiskswithcount"

  #Module variables

  ManageddiskName     = "DataDisk_BE2"
  RGName              = "${module.ResourceGroupInfra.Name}"
  ManagedDiskLocation = "${var.AzureRegion}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_BE2" {
  #module source

  source = "./Modules/15 WinVMWithCount"

  #Module variables

  VMName              = "BE2"
  VMLocation          = "${var.AzureRegion}"
  VMRG                = "${module.ResourceGroupInfra.Name}"
  VMNICid             = ["${module.NICs_BE2.Ids}"]
  VMSize              = "${lookup(var.VMSize, 2)}"
  ASID                = "${module.AS_BE.Id}"
  VMStorageTier       = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName         = "${var.VMAdminName}"
  VMAdminPassword     = "${var.VMAdminPassword}"
  DataDiskId          = ["${module.DataDisks_BE2.Ids}"]
  DataDiskName        = ["${module.DataDisks_BE2.Names}"]
  DataDiskSize        = ["${module.DataDisks_BE2.Sizes}"]
  VMPublisherName     = "${lookup(var.PublisherName, 6)}"
  VMOffer             = "${lookup(var.Offer, 6)}"
  VMsku               = "${lookup(var.sku, 6)}"
  DiagnosticDiskURI   = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath = "./Scripts/telnetclientinstall.ps1"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "CustomExtensionWinForBE2" {
  #Module location
  source = "./Modules/22 CustomExtensionScriptwithtpl"

  #Module variables

  AgentName            = "CustomExtensionWinForBE2"
  AgentLocation        = "${var.AzureRegion}"
  AgentRG              = "${module.ResourceGroupInfra.Name}"
  VMName               = ["${module.VMs_BE2.Name}"]
  EnvironmentTag       = "${var.EnvironmentTag}"
  EnvironmentUsageTag  = "${var.EnvironmentUsageTag}"
  AgentPublisher       = "microsoft.compute"
  AgentType            = "customscriptextension"
  Agentversion         = "1.9"
  SettingsTemplatePath = "./Templates/CloudInitWin.tpl"
}

module "NetworkWatcherAgentForBE2" {
  #Module Location
  source = "./Modules/21 NetworkwatcheragentWin"

  #Module variables
  AgentName           = "NetworkWatcherAgentForBE2"
  AgentLocation       = "${var.AzureRegion}"
  AgentRG             = "${module.ResourceGroupInfra.Name}"
  VMName              = ["${module.VMs_BE2.Name}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

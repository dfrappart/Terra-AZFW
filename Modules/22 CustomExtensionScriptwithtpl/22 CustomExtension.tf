###################################################################################
#This module allows the creation of a CustomLinuxExtension and use a template for 
#the JSON part
###################################################################################

#Variable declaration for Module

variable "AgentCount" {
  type    = "string"
  default = 1
}

variable "AgentName" {
  type = "string"
}

variable "AgentLocation" {
  type = "string"
}

variable "AgentRG" {
  type = "string"
}

variable "VMName" {
  type = "list"
}

variable "EnvironmentTag" {
  type = "string"
}

variable "EnvironmentUsageTag" {
  type = "string"
}

variable "AgentPublisher" {
  type    = "string"
  default = "Microsoft.Azure.Extensions" #for Linux custom extension

  #default = "microsoft.compute" #For Windows custom extension
}

variable "AgentType" {
  type    = "string"
  default = "CustomScript" #default value for Linux Agent

  #default = "customscriptextension" #Default value for Windos Agent
}

variable "Agentversion" {
  type    = "string"
  default = "2.0"
}

#Variable passing the string rendered template to the settings parameter
variable "SettingsTemplatePath" {
  type = "string"
}

#Resource Creation

data "template_file" "customscripttemplate" {
  template = "${file("${path.root}${var.SettingsTemplatePath}")}"
}

resource "azurerm_virtual_machine_extension" "Terra-CustomScriptAgent" {
  count                = "${var.AgentCount}"
  name                 = "${var.AgentName}${count.index+1}"
  location             = "${var.AgentLocation}"
  resource_group_name  = "${var.AgentRG}"
  virtual_machine_name = "${element(var.VMName,count.index)}"
  publisher            = "${var.AgentPublisher}"
  type                 = "${var.AgentType}"
  type_handler_version = "${var.Agentversion}"

  settings = "${data.template_file.customscripttemplate.rendered}"

  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}

#Module Output

output "RGName" {
  value = "${var.AgentRG}"
}

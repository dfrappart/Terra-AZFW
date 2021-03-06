##############################################################
#This module allows the creation of VMs NICs with Public Ip
#And associated NSG
##############################################################


# NIC Creation 

resource "azurerm_network_interface" "TerraNICwpip" {
  count                     = "${var.NICCount}"
  name                      = "${var.NICName}${count.index+1}"
  location                  = "${var.NICLocation}"
  resource_group_name       = "${var.RGName}"
  network_security_group_id = "${var.NSGId}"

  ip_configuration {
    name                          = "ConfigIP-NIC-${var.NICName}"
    subnet_id                     = "${var.SubnetId}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(var.PublicIPId,count.index)}"
    primary                       = "${var.Primary}"
  }

  tags {
    environment = "${var.EnvironmentTag}"
    usage       = "${var.EnvironmentUsageTag}"
  }
}


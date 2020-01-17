variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "resourcegroup_name" {}
variable "location_name" {}
variable "pip_name" {}

 variable "vnet_name" {} 
 variable "vnet_address_space" {}
 variable "subnet_address_prefix" {}
variable "subnet_name" {}

variable "nic_name" {}


variable "prefix" {
  default = "prometheus"
}
############# Providers ##########################
provider "azurerm" {
  version         = "1.1.0"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
}

############ Resources ############################


# Create a resource group
resource "azurerm_resource_group" "tf101" {
  name = "${var.resourcegroup_name}"
  location = "${var.location_name}"
}



#Create virtual network 
resource "azurerm_virtual_network" "tf101" {
  name                = "${var.vnet_name}"
  address_space       = ["${var.vnet_address_space}"]
  location            = "${azurerm_resource_group.tf101.location}"
  resource_group_name = "${azurerm_resource_group.tf101.name}"
}

#create subnet 
resource "azurerm_subnet" "tf101" {
  name                 = "${var.subnet_name}"
  resource_group_name  = "${azurerm_resource_group.tf101.name}"
  virtual_network_name = "${azurerm_virtual_network.tf101.name}"
  address_prefix       = "${var.subnet_address_prefix}"
}

#Create Public IP
#########################
#Create Public IP
#Create Public IP
resource "azurerm_public_ip" "tf101" {
name = "${var.prefix}-pip01"
location = "${var.location_name}"
resource_group_name = "${azurerm_resource_group.tf101.name}"
public_ip_address_allocation = "static"
idle_timeout_in_minutes = 30
tags = {
environment = "POC"
}
}


##########################

#create NIC
resource "azurerm_network_interface" "tf101" {
  name                = "${var.prefix}-nic01"
  location            = "${azurerm_resource_group.tf101.location}"
  resource_group_name = "${azurerm_resource_group.tf101.name}"

  ip_configuration {
    name                          = "${var.nic_name}"
    subnet_id                     = "${azurerm_subnet.tf101.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.tf101.id}"
  
   
  }

  tags = {
    environment = "staging"
  }
}


#Create VM 

resource "azurerm_virtual_machine" "tf101" {
  name                  = "${var.prefix}-vm"
  location              = "${azurerm_resource_group.tf101.location}"
  resource_group_name   = "${azurerm_resource_group.tf101.name}"
  network_interface_ids = ["${azurerm_network_interface.tf101.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "promethus"
    admin_username = "admincorp"
    admin_password = "Rainbow1001!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
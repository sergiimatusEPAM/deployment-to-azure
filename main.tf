
terraform {
  required_version = ">=0.14.7"
  backend "azurerm" {
  }
}

provider "azurerm" {
  version                    = ">= 2.0"
  skip_provider_registration = true
  features {}

}

provider "random" {
  version = "~> 2.3"
}

locals {
  global_tags = merge({ environment = var.vm_name }, var.environment_tags)
}

resource "azurerm_network_interface" "nic" {

  name                = "${var.vm_name}-nic-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.global_tags

  ip_configuration {
    name                          = "${var.vm_name}-nic-config-${var.location}"
    subnet_id                     = data.azurerm_subnet.enterprise_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_public_ip" "publicip" {
  name                = "${var.vm_name}-ip-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  tags                = local.global_tags
}

resource "azurerm_windows_virtual_machine" "vm" {

  name                = "${var.vm_name}-vm-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.global_tags

  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  computer_name  = var.vm_name
  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk {
    name                 = "${var.vm_name}-os-disk-${var.location}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

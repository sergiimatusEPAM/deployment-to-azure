provider "azurerm" {
  version                    = ">= 2.0"
  skip_provider_registration = true
  features {}

}

resource "azurerm_resource_group" "demo-rg" {
  name = "demo-rg"
  location = "UK South"
}

data "azurerm_resource_group" "demo-rg" {
  depends_on = [azurerm_resource_group.demo-rg]
  name = "demo-rg"
}

output "resource_group_id" {
  value = data.azurerm_resource_group.demo-rg.id
}

resource "azurerm_virtual_network" "test" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = data.azurerm_resource_group.demo-rg.name
  location            = data.azurerm_resource_group.demo-rg.location
}

resource "azurerm_subnet" "test-subnet" {
  name                 = "acctsub"
  resource_group_name  = data.azurerm_resource_group.demo-rg.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "test-network" {
  name                = "acctni"
  resource_group_name = data.azurerm_resource_group.demo-rg.name
  location            = data.azurerm_resource_group.demo-rg.location

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.test-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_storage_account" "test-storage-account" {
  name                     = "storageaccount"
  resource_group_name      = azurerm_resource_group.demo-rg.name
  location                 = azurerm_resource_group.demo-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "test-container" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.test-storage-account
  container_access_type = "private"
}


resource "azurerm_virtual_machine" "test-vm" {
  name                  = "testvm"
  resource_group_name   = data.azurerm_resource_group.demo-rg.name
  location              = data.azurerm_resource_group.demo-rg.location
  network_interface_ids = [azurerm_network_interface.test-network.id]
  vm_size               = "Standard_F2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "myosdisk1"
    vhd_uri       = "${azurerm_storage_account.test-storage-account.primary_blob_endpoint}${azurerm_storage_container.test-container.name}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "N0M@tt3rPassword54321"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}
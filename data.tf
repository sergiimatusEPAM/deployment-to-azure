data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

data "azurerm_subnet" "enterprise_subnet" {
  name                 = var.enterprise_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_subnet" "aks_pub_subnet" {
  name                 = var.public_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}

data "azurerm_subnet" "restricted_subnet" {
  name		       = var.restricted_subnet_name
   virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resource_group_name
}
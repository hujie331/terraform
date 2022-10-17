terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name = "mainnetwork"
  location = "eastus"
  
}

resource "azurerm_virtual_network" "main-1" {
  name = "main-1"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space = ["10.0.0.0/16"]

  
}

resource "azurerm_virtual_network" "main-2" {
  name                = "maint-2"
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.main.location
}

resource "azurerm_virtual_network_peering" "main-1" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.main-1.name
  remote_virtual_network_id = azurerm_virtual_network.main-2.id
}

resource "azurerm_virtual_network_peering" "main-2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.main.name
  virtual_network_name      = azurerm_virtual_network.main-2.name
  remote_virtual_network_id = azurerm_virtual_network.main-1.id
}

resource "azurerm_subnet" "main" {
  for_each = local.subnets
  name = each.value.name
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes = each.value.address_prefix
  virtual_network_name = azurerm_virtual_network.main-1.name
  
}

resource "azurerm_subnet" "main2" {
  for_each = local.subnets2
  name = each.value.name
  resource_group_name = azurerm_resource_group.main.name
  address_prefixes = each.value.address_prefix
  virtual_network_name = azurerm_virtual_network.main-2.name
  
}


resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "example2" {
  name                = "example-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.main2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example2" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

data "azurerm_subnet" "main" {
  name = "subnet1"
  virtual_network_name = azurerm_virtual_network.main-1.name
  resource_group_name = azurerm_resource_group.main.name
}

data "azurerm_subnet" "main2" {
  name = "subnet1"
  virtual_network_name = azurerm_virtual_network.main-2.name
  resource_group_name = azurerm_resource_group.main.name
}
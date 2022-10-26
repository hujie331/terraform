resource "azurerm_resource_group" "main" {
  name     = "mainnetwork"
  location = "eastus"
}

resource "azurerm_virtual_network_peering" "dev-to-hub-peer" {
  name = "dev-to-hub-peer"
  virtual_network_name = azurerm_virtual_network.devnetwork.name
  remote_virtual_network_id = azurerm_virtual_network.hubnetwork.id
  resource_group_name = azurerm_resource_group.main.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "test-to-hub-peer" {
  name = "test-to-hub-peer"
  virtual_network_name = azurerm_virtual_network.testnetwork.name
  remote_virtual_network_id = azurerm_virtual_network.hubnetwork.id
  resource_group_name = azurerm_resource_group.main.name
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}


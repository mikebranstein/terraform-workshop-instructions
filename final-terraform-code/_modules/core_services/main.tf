#Resource Group
resource "azurerm_resource_group" "network_rg" {
    name     = "tf-az-${var.functional_name}-${var.environment}-rg"
    location = "${var.location}"
}

#Virtual Network
resource "azurerm_virtual_network" "core_vnet" {
    name                = "tf-az-${var.functional_name}--${var.environment}-vnet"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.network_rg.name}"
    address_space       = ["${var.virtual_network_address_space}"]
}

#Subnets
resource "azurerm_subnet" "management_subnet" {
    name                 = "tf-az-${var.functional_name}-mgmt-subnet"
    address_prefix       = "${var.management_subnet}"
    virtual_network_name = "${azurerm_virtual_network.core_vnet.name}"
    resource_group_name  = "${azurerm_resource_group.network_rg.name}"
}

resource "azurerm_subnet" "gateway_subnet" {
    name                 = "tf-az-${var.functional_name}-gw-subnet"
    address_prefix       = "${var.gateway_subnet}"
    virtual_network_name = "${azurerm_virtual_network.core_vnet.name}"
    resource_group_name  = "${azurerm_resource_group.network_rg.name}"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "acctestRG-220826002858015303"
  location = "West Europe"
}

resource "azurerm_virtual_network" "test" {
  name                = "acctvn-220826002858015303"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_subnet" "test" {
  name                 = "acctsub-220826002858015303"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "test" {
  name                = "acctni-220826002858015303"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "test" {
  name                 = "acctmd2-220826002858015303"
  location             = azurerm_resource_group.test.location
  resource_group_name  = azurerm_resource_group.test.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
}

resource "azurerm_virtual_machine" "test" {
  name                  = "acctvm-220826002858015303"
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = [azurerm_network_interface.test.id]
  vm_size               = "Standard_D1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osd-220826002858015303"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    disk_size_gb      = "50"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "acctmd-220826002858015303"
    create_option     = "Empty"
    disk_size_gb      = "1"
    lun               = 0
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name            = azurerm_managed_disk.test.name
    create_option   = "Attach"
    disk_size_gb    = "1"
    lun             = 1
    managed_disk_id = azurerm_managed_disk.test.id
  }

  os_profile {
    computer_name  = "hn220826002858015303"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Production"
    cost-center = "Ops"
  }
}

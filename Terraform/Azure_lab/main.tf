terraform {
  required_version = ">=0.12"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "azure-lab_rg"
  location = var.location
}
resource "azurerm_virtual_network" "vnet_example" {
  name                = "vnet-azure-lab"
  address_space       = [var.vnet_address_space]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
resource "azurerm_subnet" "public" {
  name                 = "subnet-azure-lab"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_example.name
  address_prefixes     = [var.subnet_prefixes]
}
# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-azure-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "deny_all_inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface" "nic" {
  name                = "nic-azure-lab"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-azure-lab"
    subnet_id                     = azurerm_subnet.public.id
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
# resource "azurerm_linux_virtual_machine" "linux_vm" {
#   name                = "vm-azure-lab${count.index}"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   vm_size                = var.vm_size

#   network_interface_ids = [element(azurerm_network_interface.nic[*].id, count.index)]

#   admin_username = var.admin_username
#   admin_password = var.admin_password

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#     name                 = "osdisk-${count.index}"
#   }
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }
#   computer_name = "hostname-${count.index}"

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
#   }


# }
resource "azurerm_virtual_machine" "main" {
  name                  = "Linux-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
resource "azurerm_virtual_machine_extension" "example" {
  name                 = "customScript"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = jsonencode({
    "commandToExecute" = "bash -c '${file("${path.module}/docker.sh")}'"
  })
}


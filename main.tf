# Le compte de stockage Backend pour le Terraform tfstate.

terraform {
  backend "azurerm" {
    resource_group_name  = "RG-CR460-AZ-Terra"
    storage_account_name = "cr460cloudazure2025"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }

  # Définition et configuration du provider Azure

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

provider "azurerm" {
  features {}

}

# Groupe de ressources
resource "azurerm_resource_group" "CR460-2025" {
  name     = "CR460-2025"
  location = "East US"
}
output "resource_groupe_name" {
  value = azurerm_resource_group.CR460-2025.name
}

# Réseau virtuel
resource "azurerm_virtual_network" "CR460-2025" {
  name                = "CR460-2025-vnet"
  location            = azurerm_resource_group.CR460-2025.location
  resource_group_name = azurerm_resource_group.CR460-2025.name
  address_space       = ["10.0.0.0/16"]
}

# Sous-réseau
resource "azurerm_subnet" "CR460-2025" {
  name                 = "CR460-2025-subnet"
  resource_group_name  = azurerm_resource_group.CR460-2025.name
  virtual_network_name = azurerm_virtual_network.CR460-2025.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Adresse IP publique
resource "azurerm_public_ip" "CR460-2025" {
  name                = "CR460-2025-ip"
  location            = azurerm_resource_group.CR460-2025.location
  resource_group_name = azurerm_resource_group.CR460-2025.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Interface réseau
resource "azurerm_network_interface" "CR460-2025" {
  name                = "CR460-2025-nic"
  location            = azurerm_resource_group.CR460-2025.location
  resource_group_name = azurerm_resource_group.CR460-2025.name
  ip_configuration {
    name                          = "CR460-2025-ipconfig"
    subnet_id                     = azurerm_subnet.CR460-2025.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.CR460-2025.id
  }
}
# Machine virtuelle
resource "azurerm_virtual_machine" "CR460-2025" {
  name                  = "CR460-2025-vm"
  location              = azurerm_resource_group.CR460-2025.location
  resource_group_name   = azurerm_resource_group.CR460-2025.name
  network_interface_ids = [azurerm_network_interface.CR460-2025.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "CR460-2025-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "CR460-2025-vm"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
} # Fin de la machine virtuelle
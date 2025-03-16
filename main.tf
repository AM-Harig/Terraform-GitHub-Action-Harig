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

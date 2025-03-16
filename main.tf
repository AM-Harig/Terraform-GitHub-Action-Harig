terraform {
  backend "azurerm" {
    resource_group_name  = "RG-CR460-AZ-Terra"
    storage_account_name = "cr460cloudazure2025"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.22.0"
    }
  }
}

# Fournisseur Azure
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
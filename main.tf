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
# Déploiement d’un container Docker à partir de votre pipeline dans MS Azure
resource "azurerm_container_group" "CR460-2025" {
  name                = "docker-ameur-cr460-container"
  location            = azurerm_resource_group.CR460-2025.location
  resource_group_name = azurerm_resource_group.CR460-2025.name
  os_type             = "Linux"

  container {
    name   = "docker-ameur-cr460-container"
    image  = "mcr.microsoft.com/oss/nginx/nginx:1.9.15-alpine"
    cpu    = "1"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
  # Fin Déploiement d’un container Docker à partir de votre pipeline dans MS Azure
  # Adresse IP publique
  ip_address_type = "Public"
  dns_name_label  = "cr460-docker-container"
}
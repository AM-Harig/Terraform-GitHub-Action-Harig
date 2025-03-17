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

# Déploiement d’un container Docker à partir de votre pipeline dans MS Azure
provider "docker" {
  # host = azurerm_container_registry.acr.login_server
  registry_auth {
    address  = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
}

# Groupe de ressources
resource "azurerm_resource_group" "Docker-CR460-2025" {
  name     = "CR460-2025"
  location = "East US"
}

resource "docker_registry_image" "Docker-CR460-2025" {
  name = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"

  build {
    context    = "${path.cwd}/absolutePathToContextFolder"
    dockerfile = "Dockerfile"
  }

}

resource "azurerm_container_group" "Docker-CR460-2025" {
  name                = "kaexample-container"
  location            = azurerm_resource_group.Docker-CR460-2025.location
  resource_group_name = azurerm_resource_group.Docker-CR460-2025.name
  ip_address_type     = "Public"
  dns_name_label      = "kavyaaci-label"
  os_type             = "Linux"
  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
  tags = {
    environment = "testing"
  }
}
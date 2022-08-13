terraform {}

provider "azurerm" {
  use_oidc = true
  features {}
}

resource "azurerm_resource_group" "tfstate" {
  name     = "tfstate"
  location = "South Central US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "sttfstate001"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}
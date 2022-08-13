terraform {}

provider "azurerm" {
  use_oidc  = true
  client_id = "6f8856bb-855f-462b-8c4c-4bfe34cc4d84"
  tenant_id = "b3cbb45e-6152-433f-bfe2-ac90a78d1408"

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
  # allow_blob_public_access = true
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}
terraform {}

provider "azurerm" {
  use_oidc        = true
  client_id       = "6f8856bb-855f-462b-8c4c-4bfe34cc4d84"
  tenant_id       = "b3cbb45e-6152-433f-bfe2-ac90a78d1408"
  subscription_id = "169aa2b8-a099-41ff-b9d6-0447c8a3c047"

  features {}
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-terraform-prod-001"
  location = "South Central US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "stterraformprod001"
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
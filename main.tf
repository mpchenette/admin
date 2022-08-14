variable "owners_of_administrative_apps" {
  type = list(string)
}

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.27.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.18.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-prod-001"
    storage_account_name = "stterraformprod001"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
    tenant_id            = "b3cbb45e-6152-433f-bfe2-ac90a78d1408"
    subscription_id      = "169aa2b8-a099-41ff-b9d6-0447c8a3c047"
    client_id            = "6f8856bb-855f-462b-8c4c-4bfe34cc4d84"
  }
  required_version = ">= 1.1.0"
}

provider "azuread" {
  tenant_id = "b3cbb45e-6152-433f-bfe2-ac90a78d1408"
}

resource "azuread_group" "aad_aao_group" {
  display_name            = "Administrative Applications - Owners"
  owners                  = var.owners_of_administrative_apps
  prevent_duplicate_names = true
  security_enabled        = true
  visibility              = "Public"
}

resource "azuread_application" "aad_app" {
  display_name            = "Application Creator"
  owners                  = var.owners_of_administrative_apps
  prevent_duplicate_names = true
}



provider "azurerm" {
  use_oidc        = true
  client_id       = "6f8856bb-855f-462b-8c4c-4bfe34cc4d84"
  tenant_id       = "b3cbb45e-6152-433f-bfe2-ac90a78d1408"
  subscription_id = "169aa2b8-a099-41ff-b9d6-0447c8a3c047"

  features {}
}

# resource "azurerm_resource_group" "tfstate" {
#   name     = "rg-terraform-prod-001"
#   location = "South Central US"
# }

# resource "azurerm_storage_account" "tfstate" {
#   name                     = "stterraformprod001"
#   resource_group_name      = azurerm_resource_group.tfstate.name
#   location                 = azurerm_resource_group.tfstate.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   # allow_blob_public_access = true
# }

# resource "azurerm_storage_container" "tfstate" {
#   name                  = "tfstate"
#   storage_account_name  = azurerm_storage_account.tfstate.name
#   container_access_type = "blob"
# }

# because of https://docs.microsoft.com/en-us/graph/permissions-reference#remarks-5, we will be granting this app Application.ReadWrite.All instead of Directory.ReadWrite.All in order to grant it the lowest needed level of permissions to do its job of creating other applications and service principals
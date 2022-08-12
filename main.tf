terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azuread" {
  tenant_id = "b3cbb45e-6152-433f-bfe2-ac90a78d1408"
}

resource "azuread_group" "aad_group" {
  display_name     = "example"
  owners           = ["84574441-38cc-4302-be53-903f57446fdb"]
  security_enabled = true
}

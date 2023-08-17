terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.69.0"
        }
    }
}

provider "azurerm" {
    subscription_id = "4cf901e6-feae-4a82-a63e-a0ab181f6fce"
    features {}
}
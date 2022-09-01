terraform {
  required_version = ">= 1.1"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.20.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.2"
    }

    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    # Empty
  }
}

provider "tls" {
  # Configuration options
}

provider "local" {
  # Configuration options
}
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


provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

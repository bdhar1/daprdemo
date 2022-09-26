
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "tls_private_key" "pkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  dns_prefix          = "daprdemo"
  node_resource_group = "${data.azurerm_resource_group.rg.name}-nodes"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "sysops"
    ssh_key {
      key_data = tls_private_key.pkey.public_key_openssh
    }
  }
}

resource "azurerm_role_assignment" "aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "local_file" "foo" {
    content  = tls_private_key.pkey.private_key_openssh
    filename = "${path.module}/aks_ssh.key"
}
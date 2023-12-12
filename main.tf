provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myAKSCluster"
  location            = "East US"
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "myakscluster"

  tags = {
    "Environment" = "Test_N5"
  }

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_resource_group" "aks" {
  name     = "newAKSResourceGroup"
  location = "East US"
}

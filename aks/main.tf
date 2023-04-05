

# Initialize azure cli config
data "azurerm_client_config" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.prefix}-${var.environment}-${var.random}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "dns-${var.prefix}-${var.environment}-aks-${var.random}" #, but need to recreate existing envs  
    
  default_node_pool {
    name = "agentpool"
    node_count = var.aks_node_count
    vm_size = var.aks_node_vm_size
    os_disk_size_gb = var.aks_agent_os_disk_size
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.common_tags, { Name = "aks-${var.prefix}-${var.environment}" }) 
}

## Create Static Public IP Address to be used by Nginx Ingress
resource "azurerm_public_ip" "nginx_ingress" {
  name                         = "pip-${var.prefix}-${var.environment}-nginx-ingress"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  allocation_method            = "Static"
  domain_name_label            = "${var.prefix}-${var.environment}-tf-demo"
  idle_timeout_in_minutes      = "30"
  sku                          = "Standard"
  
  tags = merge(var.common_tags, { Name = "pip-${var.prefix}-${var.environment}" })   
}

resource "azurerm_role_assignment" "rbac_aks" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
}

resource "azurerm_key_vault_secret" "clustername_secret" {
  name         = "cluster-name"
  value        = azurerm_kubernetes_cluster.aks.name
  key_vault_id = var.key_vault_id
}

resource "azurerm_key_vault_secret" "temp" {
  name         = "temp"
  value        = "temp secret"
  key_vault_id = var.key_vault_id
}
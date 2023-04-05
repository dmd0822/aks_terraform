
# Initialize azure cli config
data "azurerm_client_config" "current" {}

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.environment}${var.prefix}${var.random}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"

  tags     = merge(var.common_tags, { Name = "acr${var.environment}${var.prefix}${var.random}" })

  identity {
    type = "SystemAssigned"
    
  }

}

resource "azurerm_key_vault_secret" "acr_server" {
  name         = "acr-${var.environment}-server"
  value        = azurerm_container_registry.acr.login_server
  key_vault_id = var.key_vault_id
}

resource "azurerm_role_assignment" "rbac_acrpush" {
  principal_id                     = data.azurerm_client_config.current.object_id
  role_definition_name             = "AcrPush"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
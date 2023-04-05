

# Initialize azure cli config
data "azurerm_client_config" "current" {}

resource "azurerm_log_analytics_workspace" "la_workspace" {
  name                = "law-${var.environment}-${var.app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  
  tags     = merge(var.common_tags, { Name = "law-${var.environment}-${var.app_name}" })
}

resource "azurerm_application_insights" "app_insights" {
  name                = "appi-${var.environment}-${var.app_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.la_workspace.id
  application_type    = "web"

  tags     = merge(var.common_tags, { Name = "appi-${var.environment}-${var.app_name}" })
}

resource "azurerm_key_vault_secret" "app_key" {
  name         = "api-${var.environment}-key"
  value        = azurerm_application_insights.app_insights.instrumentation_key
  key_vault_id = var.key_vault_id
}


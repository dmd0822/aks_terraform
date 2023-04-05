terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_rg"
    storage_account_name = "terraformstatedmd"
    container_name       = "terraform-states"
    key                  = "tfsandbox"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  skip_provider_registration = true
  features {}
}

locals {
  common_tags = {
    source      = "terraform"
    Environment = var.environment_tag
    BillingCode = var.billing_code_tag
  }
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

module "kv" {
  source              = "./keyvault"
  prefix              = var.prefix
  random              = random_integer.ri.result
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  environment         = var.environment_tag
  app_name            = var.app_name
  common_tags         = local.common_tags
}

module "acr" {
  source              = "./acr"
  prefix              = var.prefix
  random              = random_integer.ri.result
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  environment         = var.environment_tag
  app_name            = var.app_name
  key_vault_id        = module.kv.kv_id
  common_tags         = local.common_tags
}

module "appi" {
  source              = "./appi"
  prefix              = var.prefix
  random              = random_integer.ri.result
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  environment         = var.environment_tag
  app_name            = var.app_name
  key_vault_id        = module.kv.kv_id
  common_tags         = local.common_tags
}

module "aks" {
  source              = "./aks"
  prefix              = var.prefix
  random              = random_integer.ri.result
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  app_name            = var.app_name
  environment         = var.environment_tag
  key_vault_id        = module.kv.kv_id
  acr_id              = module.acr.acr_id
  common_tags         = local.common_tags
}

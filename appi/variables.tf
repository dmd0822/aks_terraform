variable "prefix" {
  description = "The prefix is written at the beginning of the name of each element"
}
variable "location" {
  default     = "eastus"
  description = "The Azure Region in which all resources should be provisioned"
}

variable "environment" {
  description = "The environment uses for azure resource tags"
}
variable "random" {
  description = "The random uses for name of each element after the environment"
}

variable "resource_group_name" {
  description = "resource_group_name"
}

variable "common_tags"{
  description = "Tags for resources"
}

variable "app_name"{
  description = "Name of the applicaiton"
}

variable "key_vault_id" {
  description = "key_vault_id"
}
variable "resource_group_name" {
    description = "Name of the resource group."
}

variable "billing_code_tag" {
    default     = "ABC123"
}
variable "environment_tag" { 
    default     = "dev"
}
variable "prefix" {
  default     = "dmd"
  description = "The prefix is written at the beginning of the name of each element"
}
#Change
variable "app_name"{
  description = "Name of the applicaiton"
}
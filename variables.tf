variable "region" { type = string }
variable "id" { type = string }

variable "subscription_id" {
  type        = string
  description = "azure subscription to deploy all infra to"
}
variable "location" {
  type        = string
  description = "azure region to deploy all infra to"
}
variable "resource_group_name"{
  type        = string
  description = "VM resource group name"
}
variable "vm_name" {
  type        = string
  description = "the base name of VM to deploy"
}
variable "vm_size" {
  type        = string
  default     = "Standard_D2_v4"
  description = "the size of VM to deploy"
}
variable "admin_username" {
  type        = string
  description = "the administrator's user name"
}
variable "admin_password" {
  type        = string
  description = "the administrator's password"
}
variable "vnet_name"{
  type        = string
  description = "vnet name"
}
variable "vnet_resource_group_name"{
  type        = string
  description = "vnet resource group name"
}
variable "azurerm_subnet_name"{
  type        = string
  description = "subnet name"
}
variable "environment_tags" {
  type        = map(string)
  description = "tags to be added to all resources created by this environment"
  default     = {}
}
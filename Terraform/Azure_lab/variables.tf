variable "location" {
  type        = string
  default     = "East US 2"
  description = "The location/region where the Azure resources will be created."
}
variable "vnet_address_space" {
  description = "The address space that will be used by the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_prefixes" {
  description = "The prefixes that will be used by the subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "instance_count" {
  description = "The number of instances that will be created."
  type        = number
  default     = 2
}
variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_B1s"
}
variable "admin_username" {
  description = "The username that will be used to login to the virtual machine."
  type        = string
}
variable "admin_password" {
  description = "The password that will be used to login to the virtual machine."
  type        = string
  sensitive   = true
}
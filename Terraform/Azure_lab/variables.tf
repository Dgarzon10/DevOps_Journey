variable "location" {
  description = "Azure region for resources"
  default     = "East US 2"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  default     = "10.0.0.0/16"
}

variable "subnet_prefixes" {
  description = "Prefixes for subnets in the virtual network"
  default     = "10.0.1.0/24"
}

variable "instance_count" {
  description = "Number of virtual machine instances"
  default     = 1
}

variable "vm_size" {
  description = "Size of the virtual machine"
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the virtual machine"
  default     = "SecurePassword123!" # No recomendado
}


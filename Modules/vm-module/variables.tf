variable "location" {
  type        = string
  description = "Location"
}

variable "rg" {
  type        = string
  description = "Resource group"
}

variable "pip_name" {
  type        = string
  description = "Public IP address name"
}

variable "pip_allocation_method" {
  type        = string
  description = "Public IP allocation method"
  default     = "Static"
}

variable "nic_name" {
  type        = string
  description = "Network interface name"
}

variable "subnet_id" {
  type        = string
  description = "Private subnet ID"
}

variable "vm_name" {
  type        = string
  description = "Virtual machine name"
}

variable "vm_pass" {
  type        = string
  description = "Virtual machine password"
}

variable "user" {
  type        = string
  description = "Username"
  default     = "adminUsername"
}


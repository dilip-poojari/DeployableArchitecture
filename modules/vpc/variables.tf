##############################################################################
# VPC Module Variables
##############################################################################

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets"
  type        = list(string)
}

variable "enable_public_gateway" {
  description = "Enable public gateway for internet access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "List of tags"
  type        = list(string)
  default     = []
}

variable "classic_access" {
  description = "Enable classic infrastructure access"
  type        = bool
  default     = false
}

variable "default_network_acl_name" {
  description = "Name of the default network ACL"
  type        = string
  default     = null
}

variable "default_security_group_name" {
  description = "Name of the default security group"
  type        = string
  default     = null
}

variable "default_routing_table_name" {
  description = "Name of the default routing table"
  type        = string
  default     = null
}

variable "address_prefix_management" {
  description = "Address prefix management (auto or manual)"
  type        = string
  default     = "auto"
  validation {
    condition     = contains(["auto", "manual"], var.address_prefix_management)
    error_message = "Address prefix management must be 'auto' or 'manual'."
  }
}
##############################################################################
# Basic Example Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "IBM Cloud API key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-south"
}

variable "resource_group_id" {
  description = "Resource group ID"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "basic-openshift-ai"
}
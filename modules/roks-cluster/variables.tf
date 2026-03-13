##############################################################################
# ROKS Cluster Module Variables
##############################################################################

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the OpenShift cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the cluster"
  type        = list(string)
}

variable "zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "openshift_version" {
  description = "OpenShift version to deploy"
  type        = string
  default     = "4.15_openshift"
}

variable "worker_pool_flavor" {
  description = "Machine type for worker nodes"
  type        = string
  default     = "bx2.16x64"
}

variable "workers_per_zone" {
  description = "Number of worker nodes per zone"
  type        = number
  default     = 2
}

variable "disable_public_service_endpoint" {
  description = "Disable public service endpoint"
  type        = bool
  default     = false
}

variable "kms_config" {
  description = "KMS configuration for cluster encryption"
  type = object({
    crk_id           = string
    instance_id      = string
    private_endpoint = optional(bool, true)
  })
  default = null
}

variable "cluster_addons" {
  description = "Map of cluster add-ons to enable"
  type = map(object({
    version = string
  }))
  default = {}
}

variable "wait_for_cluster_ready" {
  description = "Wait for cluster to be fully ready"
  type        = bool
  default     = true
}

variable "cluster_ready_timeout" {
  description = "Timeout in minutes to wait for cluster"
  type        = number
  default     = 90
}

variable "force_delete_storage" {
  description = "Force delete storage on cluster destroy"
  type        = bool
  default     = false
}

variable "tags" {
  description = "List of tags"
  type        = list(string)
  default     = []
}

variable "operating_system" {
  description = "Operating system for worker nodes"
  type        = string
  default     = "REDHAT_8_64"
  validation {
    condition     = contains(["REDHAT_8_64", "REDHAT_9_64"], var.operating_system)
    error_message = "Operating system must be REDHAT_8_64 or REDHAT_9_64."
  }
}

variable "entitlement" {
  description = "OpenShift entitlement (cloud_pak for Cloud Pak entitlement)"
  type        = string
  default     = null
}

variable "cos_instance_crn" {
  description = "CRN of Cloud Object Storage instance for image registry"
  type        = string
  default     = null
}

variable "pod_subnet" {
  description = "Custom subnet CIDR for pods"
  type        = string
  default     = null
}

variable "service_subnet" {
  description = "Custom subnet CIDR for services"
  type        = string
  default     = null
}

variable "worker_labels" {
  description = "Labels to add to worker nodes"
  type        = map(string)
  default     = {}
}

variable "disable_outbound_traffic_protection" {
  description = "Disable outbound traffic protection"
  type        = bool
  default     = false
}
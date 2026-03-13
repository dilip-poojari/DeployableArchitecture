##############################################################################
# Storage ODF Module Variables
##############################################################################

variable "cluster_id" {
  description = "ID of the OpenShift cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the OpenShift cluster"
  type        = string
}

variable "resource_group_id" {
  description = "ID of the resource group"
  type        = string
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
}

variable "odf_version" {
  description = "Version of ODF operator to install"
  type        = string
  default     = "4.15"
}

variable "odf_storage_class" {
  description = "Storage class to use for ODF"
  type        = string
  default     = "ibmc-vpc-block-metro-10iops-tier"
}

variable "odf_billing_type" {
  description = "Billing type for ODF (essentials or advanced)"
  type        = string
  default     = "advanced"
  validation {
    condition     = contains(["essentials", "advanced"], var.odf_billing_type)
    error_message = "ODF billing type must be either 'essentials' or 'advanced'."
  }
}

variable "odf_cluster_size" {
  description = "Size of ODF cluster (small, medium, large)"
  type        = string
  default     = "medium"
  validation {
    condition     = contains(["small", "medium", "large"], var.odf_cluster_size)
    error_message = "ODF cluster size must be 'small', 'medium', or 'large'."
  }
}

variable "worker_nodes" {
  description = "Number of worker nodes in the cluster"
  type        = number
}

variable "tags" {
  description = "List of tags"
  type        = list(string)
  default     = []
}

variable "auto_discover_devices" {
  description = "Auto discover devices for ODF"
  type        = bool
  default     = false
}

variable "num_of_osd" {
  description = "Number of OSD volumes (1 per worker node recommended)"
  type        = number
  default     = 1
}

variable "osd_size" {
  description = "Size of OSD volumes in GB"
  type        = string
  default     = "250Gi"
}

variable "ignore_noobaa" {
  description = "Ignore NooBaa installation"
  type        = bool
  default     = false
}
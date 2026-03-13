##############################################################################
# Input Variables
##############################################################################

##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "IBM Cloud API key for authentication"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "IBM Cloud region where resources will be deployed"
  type        = string
  default     = "us-south"
  validation {
    condition     = can(regex("^(us-south|us-east|eu-gb|eu-de|jp-tok|au-syd|jp-osa|br-sao|ca-tor)$", var.region))
    error_message = "Region must be a valid IBM Cloud region."
  }
}

variable "resource_group_id" {
  description = "ID of the resource group where resources will be created"
  type        = string
}

variable "prefix" {
  description = "Prefix to be added to all resource names. Must be unique per deployment."
  type        = string
  default     = "openshift-ai"
  validation {
    condition     = can(regex("^[a-z][-a-z0-9]*$", var.prefix)) && length(var.prefix) <= 20
    error_message = "Prefix must start with a lowercase letter, contain only lowercase letters, numbers, and hyphens, and be 20 characters or less."
  }
}

variable "tags" {
  description = "List of tags to apply to all resources"
  type        = list(string)
  default     = ["terraform", "openshift-ai", "roks"]
}

##############################################################################
# VPC Variables
##############################################################################

variable "vpc_name" {
  description = "Name of the VPC to create. If not provided, will use prefix-vpc"
  type        = string
  default     = null
}

variable "create_vpc" {
  description = "Whether to create a new VPC or use an existing one"
  type        = bool
  default     = true
}

variable "existing_vpc_id" {
  description = "ID of existing VPC to use (only if create_vpc is false)"
  type        = string
  default     = null
}

variable "existing_subnet_ids" {
  description = "List of existing subnet IDs to use (only if create_vpc is false)"
  type        = list(string)
  default     = []
}

variable "number_of_zones" {
  description = "Number of availability zones to use (1-3)"
  type        = number
  default     = 3
  validation {
    condition     = var.number_of_zones >= 1 && var.number_of_zones <= 3
    error_message = "Number of zones must be between 1 and 3."
  }
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for subnets in each zone"
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.20.0/24", "10.10.30.0/24"]
}

variable "enable_public_gateway" {
  description = "Enable public gateway for internet access"
  type        = bool
  default     = true
}

##############################################################################
# ROKS Cluster Variables
##############################################################################

variable "cluster_name" {
  description = "Name of the OpenShift cluster. If not provided, will use prefix-cluster"
  type        = string
  default     = null
}

variable "openshift_version" {
  description = "OpenShift version to deploy (e.g., 4.14_openshift, 4.15_openshift)"
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
  validation {
    condition     = var.workers_per_zone >= 1
    error_message = "Must have at least 1 worker per zone."
  }
}

variable "disable_public_service_endpoint" {
  description = "Disable public service endpoint for cluster"
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
  default = {
    "vpc-block-csi-driver" = {
      version = "5.2"
    }
  }
}

##############################################################################
# OpenShift Data Foundation (ODF) Variables
##############################################################################

variable "enable_odf" {
  description = "Enable OpenShift Data Foundation for persistent storage"
  type        = bool
  default     = true
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
  description = "Size of ODF cluster (small: 0.5TiB, medium: 2TiB, large: 4TiB)"
  type        = string
  default     = "medium"
  validation {
    condition     = contains(["small", "medium", "large"], var.odf_cluster_size)
    error_message = "ODF cluster size must be 'small', 'medium', or 'large'."
  }
}

##############################################################################
# OpenShift AI Variables
##############################################################################

variable "enable_openshift_ai" {
  description = "Enable OpenShift AI installation"
  type        = bool
  default     = true
}

variable "openshift_ai_channel" {
  description = "Update channel for OpenShift AI operator"
  type        = string
  default     = "stable"
}

variable "openshift_ai_components" {
  description = "OpenShift AI components to enable"
  type = object({
    dashboard         = optional(bool, true)
    workbenches       = optional(bool, true)
    data_science_pipelines = optional(bool, true)
    model_serving     = optional(bool, true)
    kserve            = optional(bool, true)
    model_mesh        = optional(bool, true)
    ray               = optional(bool, false)
    trustyai          = optional(bool, false)
    code_flare        = optional(bool, false)
  })
  default = {
    dashboard              = true
    workbenches            = true
    data_science_pipelines = true
    model_serving          = true
    kserve                 = true
    model_mesh             = true
    ray                    = false
    trustyai               = false
    code_flare             = false
  }
}

##############################################################################
# Observability Variables
##############################################################################

variable "enable_observability" {
  description = "Enable IBM Cloud Monitoring and Logging"
  type        = bool
  default     = false
}

variable "log_analysis_instance_id" {
  description = "ID of IBM Cloud Logs instance for log forwarding"
  type        = string
  default     = null
}

variable "monitoring_instance_id" {
  description = "ID of IBM Cloud Monitoring instance"
  type        = string
  default     = null
}

variable "log_analysis_ingestion_key" {
  description = "Ingestion key for IBM Cloud Logs"
  type        = string
  sensitive   = true
  default     = null
}

##############################################################################
# Advanced Configuration
##############################################################################

variable "wait_for_cluster_ready" {
  description = "Wait for cluster to be fully ready before proceeding"
  type        = bool
  default     = true
}

variable "cluster_ready_timeout" {
  description = "Timeout in minutes to wait for cluster to be ready"
  type        = number
  default     = 90
}

variable "force_delete_storage" {
  description = "Force delete storage on cluster destroy"
  type        = bool
  default     = false
}
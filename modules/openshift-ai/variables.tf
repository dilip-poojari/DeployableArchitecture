##############################################################################
# OpenShift AI Module Variables
##############################################################################

variable "cluster_id" {
  description = "ID of the OpenShift cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the OpenShift cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint URL of the OpenShift cluster"
  type        = string
}

variable "openshift_ai_channel" {
  description = "Update channel for OpenShift AI operator"
  type        = string
  default     = "stable"
}

variable "openshift_ai_components" {
  description = "OpenShift AI components to enable"
  type = object({
    dashboard              = optional(bool, true)
    workbenches            = optional(bool, true)
    data_science_pipelines = optional(bool, true)
    model_serving          = optional(bool, true)
    kserve                 = optional(bool, true)
    model_mesh             = optional(bool, true)
    ray                    = optional(bool, false)
    trustyai               = optional(bool, false)
    code_flare             = optional(bool, false)
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

variable "storage_class" {
  description = "Storage class to use for OpenShift AI"
  type        = string
  default     = "ibmc-vpc-block-metro-10iops-tier"
}

variable "tags" {
  description = "List of tags"
  type        = list(string)
  default     = []
}

variable "wait_for_operator_ready" {
  description = "Wait for operator to be ready before proceeding"
  type        = bool
  default     = true
}

variable "operator_timeout" {
  description = "Timeout in minutes to wait for operator installation"
  type        = number
  default     = 30
}
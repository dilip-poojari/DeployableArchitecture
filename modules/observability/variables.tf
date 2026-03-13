##############################################################################
# Observability Module Variables
##############################################################################

variable "cluster_id" {
  description = "ID of the OpenShift cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the OpenShift cluster"
  type        = string
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
}

variable "log_analysis_instance_id" {
  description = "ID of IBM Cloud Logs instance"
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

variable "tags" {
  description = "List of tags"
  type        = list(string)
  default     = []
}

variable "enable_platform_logs" {
  description = "Enable platform logs"
  type        = bool
  default     = true
}

variable "enable_platform_metrics" {
  description = "Enable platform metrics"
  type        = bool
  default     = true
}
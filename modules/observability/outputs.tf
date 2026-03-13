##############################################################################
# Observability Module Outputs
##############################################################################

output "log_analysis_configured" {
  description = "Whether log analysis is configured"
  value       = var.log_analysis_instance_id != null
}

output "monitoring_configured" {
  description = "Whether monitoring is configured"
  value       = var.monitoring_instance_id != null
}

output "log_analysis_instance_id" {
  description = "ID of the log analysis instance"
  value       = var.log_analysis_instance_id
}

output "monitoring_instance_id" {
  description = "ID of the monitoring instance"
  value       = var.monitoring_instance_id
}

output "observability_status" {
  description = "Status of observability configuration"
  value = {
    log_analysis_enabled = var.log_analysis_instance_id != null
    monitoring_enabled   = var.monitoring_instance_id != null
    cluster_id          = var.cluster_id
    region              = var.region
  }
}
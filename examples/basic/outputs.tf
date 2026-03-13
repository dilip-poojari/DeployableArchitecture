##############################################################################
# Basic Example Outputs
##############################################################################

output "cluster_id" {
  description = "ID of the OpenShift cluster"
  value       = module.openshift_ai_roks.cluster_id
}

output "cluster_name" {
  description = "Name of the OpenShift cluster"
  value       = module.openshift_ai_roks.cluster_name
}

output "cluster_endpoint" {
  description = "OpenShift cluster endpoint"
  value       = module.openshift_ai_roks.cluster_endpoint
}

output "openshift_ai_dashboard_url" {
  description = "URL to access OpenShift AI dashboard"
  value       = module.openshift_ai_roks.openshift_ai_dashboard_url
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.openshift_ai_roks.vpc_id
}

output "access_instructions" {
  description = "Instructions to access the cluster"
  value       = module.openshift_ai_roks.cluster_access_instructions
}
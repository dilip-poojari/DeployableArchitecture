##############################################################################
# Output Values
##############################################################################

##############################################################################
# VPC Outputs
##############################################################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = local.vpc_id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = var.create_vpc ? module.vpc[0].vpc_name : "existing-vpc"
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = local.subnet_ids
}

output "zones" {
  description = "List of availability zones used"
  value       = local.zones
}

##############################################################################
# ROKS Cluster Outputs
##############################################################################

output "cluster_id" {
  description = "ID of the OpenShift cluster"
  value       = module.roks_cluster.cluster_id
}

output "cluster_name" {
  description = "Name of the OpenShift cluster"
  value       = module.roks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Public endpoint URL for the OpenShift cluster"
  value       = module.roks_cluster.cluster_endpoint
}

output "cluster_ingress_hostname" {
  description = "Ingress hostname for the cluster"
  value       = module.roks_cluster.ingress_hostname
}

output "cluster_crn" {
  description = "CRN of the OpenShift cluster"
  value       = module.roks_cluster.cluster_crn
}

output "cluster_version" {
  description = "OpenShift version of the cluster"
  value       = module.roks_cluster.cluster_version
}

output "cluster_state" {
  description = "State of the cluster"
  value       = module.roks_cluster.cluster_state
}

output "worker_count" {
  description = "Total number of worker nodes"
  value       = module.roks_cluster.worker_count
}

##############################################################################
# OpenShift Data Foundation Outputs
##############################################################################

output "odf_enabled" {
  description = "Whether ODF is enabled"
  value       = var.enable_odf
}

output "odf_storage_classes" {
  description = "Storage classes created by ODF"
  value       = var.enable_odf ? module.storage_odf[0].storage_classes : []
}

output "odf_version" {
  description = "Version of ODF installed"
  value       = var.enable_odf ? module.storage_odf[0].odf_version : null
}

##############################################################################
# OpenShift AI Outputs
##############################################################################

output "openshift_ai_enabled" {
  description = "Whether OpenShift AI is enabled"
  value       = var.enable_openshift_ai
}

output "openshift_ai_dashboard_url" {
  description = "URL to access OpenShift AI dashboard"
  value       = var.enable_openshift_ai ? module.openshift_ai[0].dashboard_url : null
}

output "openshift_ai_namespace" {
  description = "Namespace where OpenShift AI is installed"
  value       = var.enable_openshift_ai ? module.openshift_ai[0].namespace : null
}

output "openshift_ai_components" {
  description = "OpenShift AI components that are enabled"
  value       = var.enable_openshift_ai ? module.openshift_ai[0].enabled_components : {}
}

##############################################################################
# Observability Outputs
##############################################################################

output "observability_enabled" {
  description = "Whether observability is enabled"
  value       = var.enable_observability
}

output "log_analysis_configured" {
  description = "Whether log analysis is configured"
  value       = var.enable_observability && var.log_analysis_instance_id != null
}

output "monitoring_configured" {
  description = "Whether monitoring is configured"
  value       = var.enable_observability && var.monitoring_instance_id != null
}

##############################################################################
# Access Information
##############################################################################

output "cluster_access_instructions" {
  description = "Instructions to access the OpenShift cluster"
  value = <<-EOT
    
    ========================================
    OpenShift AI Cluster Access Information
    ========================================
    
    Cluster Name: ${module.roks_cluster.cluster_name}
    Cluster ID: ${module.roks_cluster.cluster_id}
    
    To access your cluster:
    
    1. Install the IBM Cloud CLI and OpenShift CLI:
       https://cloud.ibm.com/docs/cli
    
    2. Log in to IBM Cloud:
       ibmcloud login --apikey <your-api-key>
    
    3. Download cluster configuration:
       ibmcloud ks cluster config --cluster ${module.roks_cluster.cluster_id}
    
    4. Access OpenShift Console:
       ${module.roks_cluster.cluster_endpoint}
    
    ${var.enable_openshift_ai ? "5. Access OpenShift AI Dashboard:\n       ${module.openshift_ai[0].dashboard_url}\n" : ""}
    For more information, visit:
    https://cloud.ibm.com/docs/openshift
    
    ========================================
  EOT
}

##############################################################################
# Resource Summary
##############################################################################

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    region            = var.region
    resource_group_id = var.resource_group_id
    vpc_created       = var.create_vpc
    cluster_name      = module.roks_cluster.cluster_name
    worker_count      = module.roks_cluster.worker_count
    zones             = local.zones
    odf_enabled       = var.enable_odf
    openshift_ai_enabled = var.enable_openshift_ai
    observability_enabled = var.enable_observability
  }
}

##############################################################################
# Cost Estimation Information
##############################################################################

output "estimated_monthly_cost_info" {
  description = "Information about estimated monthly costs"
  value = <<-EOT
    
    ========================================
    Estimated Monthly Cost Information
    ========================================
    
    This deployment includes:
    - VPC Infrastructure (subnets, gateways)
    - ROKS Cluster (${var.workers_per_zone * var.number_of_zones} workers, ${var.worker_pool_flavor})
    ${var.enable_odf ? "- OpenShift Data Foundation (${var.odf_cluster_size} cluster)" : ""}
    ${var.enable_openshift_ai ? "- OpenShift AI (included with ROKS)" : ""}
    ${var.enable_observability ? "- IBM Cloud Monitoring and Logging" : ""}
    
    For detailed pricing, use the IBM Cloud Cost Estimator:
    https://cloud.ibm.com/estimator
    
    Note: Actual costs may vary based on usage and data transfer.
    
    ========================================
  EOT
}
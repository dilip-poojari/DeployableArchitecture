##############################################################################
# ROKS Cluster Module Outputs
##############################################################################

output "cluster_id" {
  description = "ID of the OpenShift cluster"
  value       = ibm_container_vpc_cluster.openshift_cluster.id
}

output "cluster_name" {
  description = "Name of the OpenShift cluster"
  value       = ibm_container_vpc_cluster.openshift_cluster.name
}

output "cluster_crn" {
  description = "CRN of the OpenShift cluster"
  value       = ibm_container_vpc_cluster.openshift_cluster.crn
}

output "cluster_endpoint" {
  description = "Public endpoint URL for the cluster"
  value       = data.ibm_container_vpc_cluster.cluster.public_service_endpoint_url
}

output "cluster_private_endpoint" {
  description = "Private endpoint URL for the cluster"
  value       = data.ibm_container_vpc_cluster.cluster.private_service_endpoint_url
}

output "cluster_version" {
  description = "OpenShift version of the cluster"
  value       = data.ibm_container_vpc_cluster.cluster.kube_version
}

output "cluster_state" {
  description = "State of the cluster"
  value       = data.ibm_container_vpc_cluster.cluster.state
}

output "cluster_master_status" {
  description = "Status of the cluster master"
  value       = data.ibm_container_vpc_cluster.cluster.master_status
}

output "ingress_hostname" {
  description = "Ingress hostname for the cluster"
  value       = data.ibm_container_vpc_cluster.cluster.ingress_hostname
}

output "ingress_secret" {
  description = "Ingress secret for the cluster"
  value       = data.ibm_container_vpc_cluster.cluster.ingress_secret
  sensitive   = true
}

output "worker_count" {
  description = "Total number of worker nodes"
  value       = local.worker_count
}

output "worker_pools" {
  description = "List of worker pools"
  value       = data.ibm_container_vpc_cluster.cluster.worker_pools
}

output "workers" {
  description = "List of worker node IDs"
  value       = data.ibm_container_vpc_cluster.cluster.workers
}

output "worker_zones" {
  description = "Zones where workers are deployed"
  value       = var.zones
}

output "vpc_id" {
  description = "VPC ID where cluster is deployed"
  value       = var.vpc_id
}

output "subnet_ids" {
  description = "Subnet IDs used by the cluster"
  value       = var.subnet_ids
}

output "resource_group_id" {
  description = "Resource group ID"
  value       = var.resource_group_id
}

output "cluster_config_file_path" {
  description = "Path to download cluster config (use with ibmcloud CLI)"
  value       = "Run: ibmcloud ks cluster config --cluster ${ibm_container_vpc_cluster.openshift_cluster.id}"
}

output "openshift_console_url" {
  description = "URL to access OpenShift web console"
  value       = "https://console-openshift-console.${data.ibm_container_vpc_cluster.cluster.ingress_hostname}"
}

output "cluster_info" {
  description = "Comprehensive cluster information"
  value = {
    id                = ibm_container_vpc_cluster.openshift_cluster.id
    name              = ibm_container_vpc_cluster.openshift_cluster.name
    version           = data.ibm_container_vpc_cluster.cluster.kube_version
    state             = data.ibm_container_vpc_cluster.cluster.state
    worker_count      = local.worker_count
    zones             = var.zones
    public_endpoint   = data.ibm_container_vpc_cluster.cluster.public_service_endpoint_url
    private_endpoint  = data.ibm_container_vpc_cluster.cluster.private_service_endpoint_url
    ingress_hostname  = data.ibm_container_vpc_cluster.cluster.ingress_hostname
  }
}
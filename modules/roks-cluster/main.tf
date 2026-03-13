##############################################################################
# ROKS Cluster Module - Main Configuration
##############################################################################

##############################################################################
# Local Variables
##############################################################################

locals {
  # Calculate total worker count
  worker_count = var.workers_per_zone * length(var.zones)
  
  # Default worker pool name
  default_worker_pool_name = "${var.cluster_name}-default-pool"
  
  # Cluster timeout in seconds
  timeout_seconds = var.cluster_ready_timeout * 60
}

##############################################################################
# OpenShift Cluster
##############################################################################

resource "ibm_container_vpc_cluster" "openshift_cluster" {
  name              = var.cluster_name
  vpc_id            = var.vpc_id
  resource_group_id = var.resource_group_id
  flavor            = var.worker_pool_flavor
  worker_count      = var.workers_per_zone
  kube_version      = var.openshift_version
  tags              = var.tags
  
  # Zones and subnets
  dynamic "zones" {
    for_each = var.zones
    content {
      name      = zones.value
      subnet_id = var.subnet_ids[zones.key]
    }
  }
  
  # Service endpoints
  disable_public_service_endpoint = var.disable_public_service_endpoint
  
  # KMS encryption (optional)
  dynamic "kms_config" {
    for_each = var.kms_config != null ? [var.kms_config] : []
    content {
      crk_id           = kms_config.value.crk_id
      instance_id      = kms_config.value.instance_id
      private_endpoint = kms_config.value.private_endpoint
    }
  }
  
  # Operating system
  operating_system = var.operating_system
  
  # Entitlement (for Cloud Pak)
  entitlement = var.entitlement
  
  # COS instance for image registry
  cos_instance_crn = var.cos_instance_crn
  
  # Custom pod and service subnets
  pod_subnet     = var.pod_subnet
  service_subnet = var.service_subnet
  
  # Outbound traffic protection
  disable_outbound_traffic_protection = var.disable_outbound_traffic_protection
  
  # Wait for cluster to be ready
  wait_till = var.wait_for_cluster_ready ? "IngressReady" : "MasterNodeReady"
  
  # Force delete storage
  force_delete_storage = var.force_delete_storage
  
  timeouts {
    create = "${var.cluster_ready_timeout}m"
    update = "${var.cluster_ready_timeout}m"
    delete = "2h"
  }
}

##############################################################################
# Worker Pool Labels (if specified)
##############################################################################

resource "ibm_container_vpc_worker_pool" "additional_pool" {
  count = length(var.worker_labels) > 0 ? 0 : 0  # Disabled by default, can be enabled for additional pools
  
  cluster           = ibm_container_vpc_cluster.openshift_cluster.id
  worker_pool_name  = "${var.cluster_name}-additional-pool"
  flavor            = var.worker_pool_flavor
  vpc_id            = var.vpc_id
  worker_count      = var.workers_per_zone
  resource_group_id = var.resource_group_id
  
  dynamic "zones" {
    for_each = var.zones
    content {
      name      = zones.value
      subnet_id = var.subnet_ids[zones.key]
    }
  }
  
  labels = var.worker_labels
}

##############################################################################
# Cluster Add-ons
##############################################################################

resource "ibm_container_addons" "cluster_addons" {
  count = length(var.cluster_addons) > 0 ? 1 : 0
  
  cluster = ibm_container_vpc_cluster.openshift_cluster.id
  
  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name    = addons.key
      version = addons.value.version
    }
  }
  
  resource_group_id = var.resource_group_id
}

##############################################################################
# Wait for Cluster to be Fully Ready
##############################################################################

resource "time_sleep" "wait_for_cluster" {
  depends_on = [
    ibm_container_vpc_cluster.openshift_cluster,
    ibm_container_addons.cluster_addons
  ]
  
  create_duration = var.wait_for_cluster_ready ? "5m" : "30s"
}

##############################################################################
# Data Source to Get Cluster Configuration
##############################################################################

data "ibm_container_vpc_cluster" "cluster" {
  depends_on = [time_sleep.wait_for_cluster]
  
  name              = ibm_container_vpc_cluster.openshift_cluster.name
  resource_group_id = var.resource_group_id
}

##############################################################################
# Data Source to Get Cluster Workers
##############################################################################

data "ibm_container_vpc_cluster_worker" "cluster_workers" {
  depends_on = [time_sleep.wait_for_cluster]
  
  count             = local.worker_count
  cluster_name_id   = ibm_container_vpc_cluster.openshift_cluster.id
  resource_group_id = var.resource_group_id
  worker_id         = data.ibm_container_vpc_cluster.cluster.workers[count.index]
}
##############################################################################
# OpenShift AI on IBM Cloud ROKS - Main Configuration
##############################################################################

##############################################################################
# Provider Configuration
##############################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

##############################################################################
# Local Variables
##############################################################################

locals {
  vpc_name     = var.vpc_name != null ? var.vpc_name : "${var.prefix}-vpc"
  cluster_name = var.cluster_name != null ? var.cluster_name : "${var.prefix}-cluster"
  
  # Determine zones based on region and number_of_zones
  zones = slice(data.ibm_is_zones.regional.zones, 0, var.number_of_zones)
  
  # VPC and subnet IDs
  vpc_id     = var.create_vpc ? module.vpc[0].vpc_id : var.existing_vpc_id
  subnet_ids = var.create_vpc ? module.vpc[0].subnet_ids : var.existing_subnet_ids
  
  # Common tags
  common_tags = concat(var.tags, [
    "deployment:openshift-ai",
    "managed-by:terraform"
  ])
}

##############################################################################
# Data Sources
##############################################################################

data "ibm_is_zones" "regional" {
  region = var.region
}

data "ibm_resource_group" "group" {
  id = var.resource_group_id
}

##############################################################################
# VPC Module
##############################################################################

module "vpc" {
  count  = var.create_vpc ? 1 : 0
  source = "./modules/vpc"

  resource_group_id      = var.resource_group_id
  region                 = var.region
  prefix                 = var.prefix
  vpc_name               = local.vpc_name
  zones                  = local.zones
  subnet_cidr_blocks     = var.subnet_cidr_blocks
  enable_public_gateway  = var.enable_public_gateway
  tags                   = local.common_tags
}

##############################################################################
# ROKS Cluster Module
##############################################################################

module "roks_cluster" {
  source = "./modules/roks-cluster"

  # Dependencies
  depends_on = [module.vpc]

  # Basic Configuration
  resource_group_id = var.resource_group_id
  region            = var.region
  cluster_name      = local.cluster_name
  
  # VPC Configuration
  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids
  zones      = local.zones
  
  # Cluster Configuration
  openshift_version                = var.openshift_version
  worker_pool_flavor               = var.worker_pool_flavor
  workers_per_zone                 = var.workers_per_zone
  disable_public_service_endpoint  = var.disable_public_service_endpoint
  
  # Security
  kms_config = var.kms_config
  
  # Add-ons
  cluster_addons = var.cluster_addons
  
  # Operational
  wait_for_cluster_ready = var.wait_for_cluster_ready
  cluster_ready_timeout  = var.cluster_ready_timeout
  force_delete_storage   = var.force_delete_storage
  
  tags = local.common_tags
}

##############################################################################
# OpenShift Data Foundation (ODF) Module
##############################################################################

module "storage_odf" {
  count  = var.enable_odf ? 1 : 0
  source = "./modules/storage-odf"

  # Dependencies
  depends_on = [module.roks_cluster]

  # Cluster Configuration
  cluster_id            = module.roks_cluster.cluster_id
  cluster_name          = module.roks_cluster.cluster_name
  resource_group_id     = var.resource_group_id
  region                = var.region
  
  # ODF Configuration
  odf_version       = var.odf_version
  odf_storage_class = var.odf_storage_class
  odf_billing_type  = var.odf_billing_type
  odf_cluster_size  = var.odf_cluster_size
  
  # Worker Configuration
  worker_nodes = module.roks_cluster.worker_count
  
  tags = local.common_tags
}

##############################################################################
# OpenShift AI Module
##############################################################################

module "openshift_ai" {
  count  = var.enable_openshift_ai ? 1 : 0
  source = "./modules/openshift-ai"

  # Dependencies - Wait for ODF if enabled
  depends_on = [
    module.roks_cluster,
    module.storage_odf
  ]

  # Cluster Configuration
  cluster_id       = module.roks_cluster.cluster_id
  cluster_name     = module.roks_cluster.cluster_name
  cluster_endpoint = module.roks_cluster.cluster_endpoint
  
  # OpenShift AI Configuration
  openshift_ai_channel    = var.openshift_ai_channel
  openshift_ai_components = var.openshift_ai_components
  
  # Storage Configuration
  storage_class = var.enable_odf ? "ocs-storagecluster-cephfs" : "ibmc-vpc-block-metro-10iops-tier"
  
  tags = local.common_tags
}

##############################################################################
# Observability Module (Optional)
##############################################################################

module "observability" {
  count  = var.enable_observability ? 1 : 0
  source = "./modules/observability"

  # Dependencies
  depends_on = [module.roks_cluster]

  # Cluster Configuration
  cluster_id   = module.roks_cluster.cluster_id
  cluster_name = module.roks_cluster.cluster_name
  region       = var.region
  
  # Observability Configuration
  log_analysis_instance_id    = var.log_analysis_instance_id
  monitoring_instance_id      = var.monitoring_instance_id
  log_analysis_ingestion_key  = var.log_analysis_ingestion_key
  
  tags = local.common_tags
}

##############################################################################
# Wait for OpenShift AI to be Ready
##############################################################################

resource "time_sleep" "wait_for_openshift_ai" {
  count = var.enable_openshift_ai ? 1 : 0
  
  depends_on = [module.openshift_ai]
  
  create_duration = "5m"
}
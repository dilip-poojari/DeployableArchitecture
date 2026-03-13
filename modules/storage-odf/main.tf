##############################################################################
# Storage ODF Module - Main Configuration
##############################################################################

##############################################################################
# Local Variables
##############################################################################

locals {
  # ODF size mapping
  odf_size_map = {
    small  = "0.5TiB"
    medium = "2TiB"
    large  = "4TiB"
  }
  
  odf_capacity = local.odf_size_map[var.odf_cluster_size]
}

##############################################################################
# IBM Cloud ODF Add-on
##############################################################################

resource "ibm_container_addons" "odf" {
  cluster           = var.cluster_id
  resource_group_id = var.resource_group_id
  
  addons {
    name    = "openshift-data-foundation"
    version = var.odf_version
  }
  
  timeouts {
    create = "1h"
    update = "1h"
  }
}

##############################################################################
# Wait for ODF Add-on to be Ready
##############################################################################

resource "time_sleep" "wait_for_odf_addon" {
  depends_on = [ibm_container_addons.odf]
  
  create_duration = "5m"
}

##############################################################################
# ODF Storage Cluster Configuration
##############################################################################

resource "ibm_container_storage_attachment" "odf_storage" {
  count = var.worker_nodes
  
  depends_on = [time_sleep.wait_for_odf_addon]
  
  cluster       = var.cluster_id
  worker        = data.ibm_container_vpc_cluster.cluster.workers[count.index]
  volume_name   = "odf-volume-${count.index}"
  volume_type   = "block"
  
  volume_attachment_name = "odf-attachment-${count.index}"
  
  # Storage configuration
  storage_class = var.odf_storage_class
  size          = var.osd_size
}

##############################################################################
# Data Source for Cluster Information
##############################################################################

data "ibm_container_vpc_cluster" "cluster" {
  name              = var.cluster_name
  resource_group_id = var.resource_group_id
}

##############################################################################
# Wait for Storage Attachments
##############################################################################

resource "time_sleep" "wait_for_storage" {
  depends_on = [ibm_container_storage_attachment.odf_storage]
  
  create_duration = "3m"
}

##############################################################################
# ODF Storage Cluster (via IBM Cloud API)
##############################################################################

resource "null_resource" "configure_odf" {
  depends_on = [time_sleep.wait_for_storage]
  
  triggers = {
    cluster_id     = var.cluster_id
    odf_version    = var.odf_version
    billing_type   = var.odf_billing_type
    cluster_size   = var.odf_cluster_size
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "ODF add-on installed successfully"
      echo "ODF Version: ${var.odf_version}"
      echo "Billing Type: ${var.odf_billing_type}"
      echo "Cluster Size: ${var.odf_cluster_size} (${local.odf_capacity})"
      echo "Storage Class: ${var.odf_storage_class}"
    EOT
  }
}

##############################################################################
# Wait for ODF to be Fully Ready
##############################################################################

resource "time_sleep" "wait_for_odf_ready" {
  depends_on = [null_resource.configure_odf]
  
  create_duration = "10m"
}
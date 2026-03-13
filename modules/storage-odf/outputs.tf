##############################################################################
# Storage ODF Module Outputs
##############################################################################

output "odf_version" {
  description = "Version of ODF installed"
  value       = var.odf_version
}

output "odf_billing_type" {
  description = "Billing type for ODF"
  value       = var.odf_billing_type
}

output "odf_cluster_size" {
  description = "Size of ODF cluster"
  value       = var.odf_cluster_size
}

output "odf_capacity" {
  description = "Total capacity of ODF cluster"
  value       = local.odf_capacity
}

output "storage_class" {
  description = "Base storage class used for ODF"
  value       = var.odf_storage_class
}

output "storage_classes" {
  description = "Storage classes created by ODF"
  value = [
    "ocs-storagecluster-ceph-rbd",
    "ocs-storagecluster-cephfs",
    "openshift-storage.noobaa.io",
    "ocs-storagecluster-ceph-rgw"
  ]
}

output "storage_classes_description" {
  description = "Description of ODF storage classes"
  value = {
    "ocs-storagecluster-ceph-rbd" = "Block storage (RWO) - For databases, VMs"
    "ocs-storagecluster-cephfs"   = "File storage (RWX) - For shared storage, AI/ML workloads"
    "openshift-storage.noobaa.io" = "Object storage (S3-compatible) - For backups, archives"
    "ocs-storagecluster-ceph-rgw" = "Object storage (RGW) - For object storage workloads"
  }
}

output "recommended_storage_class_for_ai" {
  description = "Recommended storage class for OpenShift AI workloads"
  value       = "ocs-storagecluster-cephfs"
}

output "odf_namespace" {
  description = "Namespace where ODF is installed"
  value       = "openshift-storage"
}

output "installation_complete" {
  description = "ODF installation status"
  value       = "OpenShift Data Foundation has been successfully installed and configured"
}
##############################################################################
# OpenShift AI Module Outputs
##############################################################################

output "namespace" {
  description = "Namespace where OpenShift AI operator is installed"
  value       = local.operator_namespace
}

output "app_namespace" {
  description = "Namespace where OpenShift AI applications are deployed"
  value       = local.app_namespace
}

output "operator_channel" {
  description = "Update channel for OpenShift AI operator"
  value       = var.openshift_ai_channel
}

output "enabled_components" {
  description = "OpenShift AI components that are enabled"
  value       = var.openshift_ai_components
}

output "dashboard_url" {
  description = "URL to access OpenShift AI dashboard"
  value       = "https://rhods-dashboard-${local.app_namespace}.apps.${replace(var.cluster_endpoint, "https://", "")}"
}

output "storage_class" {
  description = "Storage class used by OpenShift AI"
  value       = var.storage_class
}

output "installation_status" {
  description = "Installation status message"
  value       = "OpenShift AI has been installed. Access the dashboard at the dashboard_url output."
}

output "next_steps" {
  description = "Next steps after installation"
  value = <<-EOT
    OpenShift AI Installation Complete!
    
    Next Steps:
    1. Access the OpenShift AI dashboard using the dashboard_url output
    2. Log in with your OpenShift credentials
    3. Create a Data Science Project
    4. Launch a Jupyter notebook workbench
    5. Start building your AI/ML models
    
    For more information, visit:
    https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed
  EOT
}
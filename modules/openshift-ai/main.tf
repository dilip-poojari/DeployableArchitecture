##############################################################################
# OpenShift AI Module - Main Configuration
##############################################################################

##############################################################################
# Local Variables
##############################################################################

locals {
  # Convert boolean to managementState
  to_state = {
    true  = "Managed"
    false = "Removed"
  }
  
  # Operator namespace
  operator_namespace = "redhat-ods-operator"
  
  # Application namespace
  app_namespace = "redhat-ods-applications"
  
  # Subscription manifest
  subscription_manifest = templatefile("${path.module}/templates/subscription.yaml.tpl", {
    channel = var.openshift_ai_channel
  })
  
  # DataScienceCluster manifest
  dsc_manifest = templatefile("${path.module}/templates/datasciencecluster.yaml.tpl", {
    dashboard_enabled              = local.to_state[var.openshift_ai_components.dashboard]
    workbenches_enabled            = local.to_state[var.openshift_ai_components.workbenches]
    data_science_pipelines_enabled = local.to_state[var.openshift_ai_components.data_science_pipelines]
    model_serving_enabled          = local.to_state[var.openshift_ai_components.model_serving]
    kserve_enabled                 = local.to_state[var.openshift_ai_components.kserve]
    model_mesh_enabled             = local.to_state[var.openshift_ai_components.model_mesh]
    ray_enabled                    = local.to_state[var.openshift_ai_components.ray]
    trustyai_enabled               = local.to_state[var.openshift_ai_components.trustyai]
    code_flare_enabled             = local.to_state[var.openshift_ai_components.code_flare]
  })
}

##############################################################################
# Get Cluster Configuration
##############################################################################

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id = var.cluster_id
  config_dir      = "${path.module}/kubeconfig"
  download        = true
  admin           = true
}

##############################################################################
# Install OpenShift AI Operator
##############################################################################

resource "null_resource" "install_operator" {
  triggers = {
    cluster_id   = var.cluster_id
    subscription = local.subscription_manifest
    kubeconfig   = data.ibm_container_cluster_config.cluster_config.config_file_path
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      export KUBECONFIG="${data.ibm_container_cluster_config.cluster_config.config_file_path}"
      echo '${local.subscription_manifest}' | kubectl apply -f -
      sleep 30
    EOT
  }
}

##############################################################################
# Wait for Operator
##############################################################################

resource "time_sleep" "wait_for_operator" {
  depends_on      = [null_resource.install_operator]
  create_duration = "2m"
}

##############################################################################
# Create DataScienceCluster
##############################################################################

resource "null_resource" "create_dsc" {
  depends_on = [time_sleep.wait_for_operator]
  
  triggers = {
    cluster_id = var.cluster_id
    dsc_config = local.dsc_manifest
    kubeconfig = data.ibm_container_cluster_config.cluster_config.config_file_path
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      export KUBECONFIG="${data.ibm_container_cluster_config.cluster_config.config_file_path}"
      echo '${local.dsc_manifest}' | kubectl apply -f -
      sleep 60
    EOT
  }
}

##############################################################################
# Wait for OpenShift AI
##############################################################################

resource "time_sleep" "wait_for_openshift_ai" {
  depends_on      = [null_resource.create_dsc]
  create_duration = "3m"
}
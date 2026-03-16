##############################################################################
# Basic Example - OpenShift AI on ROKS
##############################################################################

module "openshift_ai_roks" {
  source = "../.."

  # IBM Cloud Configuration
  ibmcloud_api_key  = var.ibmcloud_api_key
  region            = var.region
  resource_group_id = var.resource_group_id
  prefix            = var.prefix

  # VPC Configuration - Use defaults
  create_vpc           = true
  number_of_zones      = 3
  enable_public_gateway = true

  # ROKS Cluster Configuration
  openshift_version  = "4.15_openshift"
  worker_pool_flavor = "bx2.16x64"
  workers_per_zone   = 2

  # Storage Configuration
  enable_odf       = true
  odf_cluster_size = "medium"

  # OpenShift AI Configuration
  enable_openshift_ai = true
  openshift_ai_components = {
    dashboard              = true
    workbenches            = true
    data_science_pipelines = true
    model_serving          = true
    kserve                 = true
    model_mesh             = true
    ray                    = false
    trustyai               = false
    code_flare             = false
  }

  # Observability - Disabled for basic example
  enable_observability = false

  # Tags
  tags = [
    "env:dev",
    "project:openshift-ai",
    "example:basic"
  ]
}
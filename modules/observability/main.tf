##############################################################################
# Observability Module - Main Configuration
##############################################################################

##############################################################################
# Log Analysis Configuration
##############################################################################

resource "ibm_ob_logging" "log_analysis" {
  count = var.log_analysis_instance_id != null ? 1 : 0
  
  cluster           = var.cluster_id
  instance_id       = var.log_analysis_instance_id
  logdna_ingestion_key = var.log_analysis_ingestion_key
  private_endpoint  = false
}

##############################################################################
# Monitoring Configuration
##############################################################################

resource "ibm_ob_monitoring" "monitoring" {
  count = var.monitoring_instance_id != null ? 1 : 0
  
  cluster          = var.cluster_id
  instance_id      = var.monitoring_instance_id
  sysdig_access_key = null  # Will use service key from instance
  private_endpoint = false
}

##############################################################################
# Platform Logs (Optional)
##############################################################################

# Note: Platform logs are configured at the account level
# This is a placeholder for documentation purposes

##############################################################################
# Platform Metrics (Optional)
##############################################################################

# Note: Platform metrics are configured at the account level
# This is a placeholder for documentation purposes
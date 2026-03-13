##############################################################################
# VPC Module - Main Configuration
##############################################################################

##############################################################################
# Local Variables
##############################################################################

locals {
  # Create subnet names based on zones
  subnet_names = [
    for idx, zone in var.zones :
    "${var.prefix}-subnet-${idx + 1}"
  ]
  
  # Create public gateway names
  pgw_names = var.enable_public_gateway ? [
    for idx, zone in var.zones :
    "${var.prefix}-pgw-${idx + 1}"
  ] : []
}

##############################################################################
# VPC
##############################################################################

resource "ibm_is_vpc" "vpc" {
  name                        = var.vpc_name
  resource_group              = var.resource_group_id
  classic_access              = var.classic_access
  address_prefix_management   = var.address_prefix_management
  default_network_acl_name    = var.default_network_acl_name
  default_security_group_name = var.default_security_group_name
  default_routing_table_name  = var.default_routing_table_name
  tags                        = var.tags
}

##############################################################################
# Public Gateways (one per zone)
##############################################################################

resource "ibm_is_public_gateway" "pgw" {
  count = var.enable_public_gateway ? length(var.zones) : 0

  name           = local.pgw_names[count.index]
  vpc            = ibm_is_vpc.vpc.id
  zone           = var.zones[count.index]
  resource_group = var.resource_group_id
  tags           = var.tags
}

##############################################################################
# Subnets (one per zone)
##############################################################################

resource "ibm_is_subnet" "subnet" {
  count = length(var.zones)

  name                     = local.subnet_names[count.index]
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = var.zones[count.index]
  ipv4_cidr_block          = var.subnet_cidr_blocks[count.index]
  resource_group           = var.resource_group_id
  public_gateway           = var.enable_public_gateway ? ibm_is_public_gateway.pgw[count.index].id : null
  tags                     = var.tags
}

##############################################################################
# Security Group for OpenShift
##############################################################################

resource "ibm_is_security_group" "openshift_sg" {
  name           = "${var.prefix}-openshift-sg"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = var.resource_group_id
  tags           = var.tags
}

# Allow all outbound traffic
resource "ibm_is_security_group_rule" "openshift_outbound" {
  group     = ibm_is_security_group.openshift_sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

# Allow inbound traffic from within VPC
resource "ibm_is_security_group_rule" "openshift_inbound_vpc" {
  group     = ibm_is_security_group.openshift_sg.id
  direction = "inbound"
  remote    = ibm_is_vpc.vpc.default_security_group
}

# Allow inbound HTTPS (443) for OpenShift console
resource "ibm_is_security_group_rule" "openshift_inbound_https" {
  group     = ibm_is_security_group.openshift_sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 443
    port_max = 443
  }
}

# Allow inbound HTTP (80) for applications
resource "ibm_is_security_group_rule" "openshift_inbound_http" {
  group     = ibm_is_security_group.openshift_sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 80
    port_max = 80
  }
}

# Allow inbound traffic on port 30000-32767 for NodePort services
resource "ibm_is_security_group_rule" "openshift_inbound_nodeport" {
  group     = ibm_is_security_group.openshift_sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 30000
    port_max = 32767
  }
}

##############################################################################
# Network ACL for additional security
##############################################################################

resource "ibm_is_network_acl" "openshift_acl" {
  name           = "${var.prefix}-openshift-acl"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = var.resource_group_id
  tags           = var.tags

  # Allow all inbound traffic (can be restricted based on requirements)
  rules {
    name        = "allow-all-inbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "inbound"
  }

  # Allow all outbound traffic
  rules {
    name        = "allow-all-outbound"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
  }
}
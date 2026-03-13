##############################################################################
# VPC Module Outputs
##############################################################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = ibm_is_vpc.vpc.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = ibm_is_vpc.vpc.name
}

output "vpc_crn" {
  description = "CRN of the VPC"
  value       = ibm_is_vpc.vpc.crn
}

output "vpc_default_security_group" {
  description = "Default security group of the VPC"
  value       = ibm_is_vpc.vpc.default_security_group
}

output "vpc_default_network_acl" {
  description = "Default network ACL of the VPC"
  value       = ibm_is_vpc.vpc.default_network_acl
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = ibm_is_subnet.subnet[*].id
}

output "subnet_names" {
  description = "List of subnet names"
  value       = ibm_is_subnet.subnet[*].name
}

output "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  value       = ibm_is_subnet.subnet[*].ipv4_cidr_block
}

output "subnet_zones" {
  description = "List of zones for subnets"
  value       = ibm_is_subnet.subnet[*].zone
}

output "public_gateway_ids" {
  description = "List of public gateway IDs"
  value       = var.enable_public_gateway ? ibm_is_public_gateway.pgw[*].id : []
}

output "public_gateway_ips" {
  description = "List of public gateway IP addresses"
  value       = var.enable_public_gateway ? ibm_is_public_gateway.pgw[*].floating_ip.address : []
}

output "security_group_id" {
  description = "ID of the OpenShift security group"
  value       = ibm_is_security_group.openshift_sg.id
}

output "security_group_name" {
  description = "Name of the OpenShift security group"
  value       = ibm_is_security_group.openshift_sg.name
}

output "network_acl_id" {
  description = "ID of the OpenShift network ACL"
  value       = ibm_is_network_acl.openshift_acl.id
}

output "zones" {
  description = "List of availability zones used"
  value       = var.zones
}
# Basic Example - OpenShift AI on ROKS

This example demonstrates a basic deployment of OpenShift AI on IBM Cloud ROKS with default configurations.

## What This Example Deploys

- **VPC**: 3-zone VPC with subnets and public gateways
- **ROKS Cluster**: OpenShift 4.15 with 6 workers (2 per zone, bx2.16x64)
- **OpenShift Data Foundation**: Medium size (2TiB) storage cluster
- **OpenShift AI**: Full platform with dashboard, workbenches, pipelines, and model serving

## Prerequisites

1. IBM Cloud account with appropriate permissions
2. IBM Cloud API key
3. Resource group ID
4. Terraform v1.3.0 or later

## Usage

### 1. Create terraform.tfvars

```hcl
ibmcloud_api_key  = "your-api-key-here"
region            = "us-south"
resource_group_id = "your-resource-group-id"
prefix            = "my-openshift-ai"
```

### 2. Initialize and Deploy

```bash
terraform init
terraform plan
terraform apply
```

### 3. Access Your Cluster

After deployment completes (60-90 minutes), access your cluster:

```bash
# Get cluster ID from outputs
export CLUSTER_ID=$(terraform output -raw cluster_id)

# Download cluster config
ibmcloud ks cluster config --cluster $CLUSTER_ID

# Verify access
oc get nodes
```

### 4. Access OpenShift AI Dashboard

```bash
# Get dashboard URL
terraform output openshift_ai_dashboard_url
```

Open the URL in your browser and log in with your OpenShift credentials.

## Estimated Monthly Cost

Approximately **$3,250-3,900 USD/month** including:
- VPC infrastructure
- 6 worker nodes (bx2.16x64)
- OpenShift Data Foundation (2TiB)
- OpenShift AI (included)

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will delete all resources including data. Ensure you have backups before destroying.

## Next Steps

After deployment:
1. Create a Data Science Project
2. Launch a Jupyter notebook workbench
3. Train and deploy your first model
4. Explore OpenShift AI features

## Support

For issues with this example, please open an issue in the repository.
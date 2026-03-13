# OpenShift AI on IBM Cloud ROKS - Deployable Architecture

This Deployable Architecture (DA) provisions a complete **OpenShift AI** environment on **IBM Cloud**, including VPC infrastructure, Red Hat OpenShift on IBM Cloud (ROKS) cluster, OpenShift Data Foundation (ODF) for persistent storage, and OpenShift AI with all necessary components for AI/ML workloads.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Modules](#modules)
- [Outputs](#outputs)
- [Cost Estimation](#cost-estimation)
- [Deployment Guide](#deployment-guide)
- [Post-Deployment](#post-deployment)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

This Deployable Architecture automates the deployment of OpenShift AI on IBM Cloud, providing a production-ready platform for:

- **Machine Learning Model Development**: Jupyter notebooks with GPU support
- **Data Science Pipelines**: Kubeflow Pipelines for ML workflows
- **Model Serving**: KServe and ModelMesh for model deployment
- **Distributed Training**: Ray for distributed ML workloads
- **MLOps**: Complete lifecycle management for AI/ML models

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        IBM Cloud VPC                         │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │   Zone 1   │  │   Zone 2   │  │   Zone 3   │            │
│  │            │  │            │  │            │            │
│  │  Subnet    │  │  Subnet    │  │  Subnet    │            │
│  │  Workers   │  │  Workers   │  │  Workers   │            │
│  └────────────┘  └────────────┘  └────────────┘            │
│         │               │               │                    │
│         └───────────────┴───────────────┘                    │
│                         │                                    │
│         ┌───────────────────────────────┐                   │
│         │   Red Hat OpenShift Cluster   │                   │
│         │                               │                   │
│         │  ┌─────────────────────────┐ │                   │
│         │  │ OpenShift Data Foundation│ │                   │
│         │  │  - Block Storage (RBD)  │ │                   │
│         │  │  - File Storage (CephFS)│ │                   │
│         │  │  - Object Storage (S3)  │ │                   │
│         │  └─────────────────────────┘ │                   │
│         │                               │                   │
│         │  ┌─────────────────────────┐ │                   │
│         │  │    OpenShift AI         │ │                   │
│         │  │  - Dashboard            │ │                   │
│         │  │  - Workbenches          │ │                   │
│         │  │  - Data Science Pipelines│ │                   │
│         │  │  - Model Serving        │ │                   │
│         │  │  - KServe/ModelMesh     │ │                   │
│         │  └─────────────────────────┘ │                   │
│         └───────────────────────────────┘                   │
└─────────────────────────────────────────────────────────────┘
```

## Features

### Infrastructure
- ✅ **Multi-Zone VPC**: High availability across 3 availability zones
- ✅ **Network Isolation**: Security groups and network ACLs
- ✅ **Public Gateway**: Internet access for worker nodes
- ✅ **Flexible Subnets**: Configurable CIDR blocks

### OpenShift Cluster
- ✅ **Managed ROKS**: Fully managed Red Hat OpenShift
- ✅ **Auto-scaling**: Configurable worker pools
- ✅ **Version Control**: Support for OpenShift 4.14+
- ✅ **Security**: KMS encryption support

### Storage (ODF)
- ✅ **Block Storage**: RWO volumes for databases
- ✅ **File Storage**: RWX volumes for shared data
- ✅ **Object Storage**: S3-compatible storage
- ✅ **Scalable**: Small (0.5TiB), Medium (2TiB), Large (4TiB)

### OpenShift AI
- ✅ **Dashboard**: Web-based management interface
- ✅ **Workbenches**: Jupyter notebooks with custom images
- ✅ **Pipelines**: Kubeflow Pipelines for ML workflows
- ✅ **Model Serving**: KServe and ModelMesh
- ✅ **Ray**: Distributed computing framework
- ✅ **TrustyAI**: Model explainability and fairness

### Observability (Optional)
- ✅ **IBM Cloud Monitoring**: Cluster and application metrics
- ✅ **IBM Cloud Logging**: Centralized log management

## Prerequisites

### Required
1. **IBM Cloud Account** with appropriate permissions
2. **IBM Cloud API Key** with Administrator access to:
   - VPC Infrastructure Services
   - Kubernetes Service
3. **Terraform** v1.3.0 or later
4. **IBM Cloud CLI** (for post-deployment access)
5. **kubectl** and **oc** CLI tools

### Permissions
- `Administrator` role on VPC Infrastructure Services
- `Administrator` role on Kubernetes Service
- `Editor` role on Resource Group

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/openshift-ai-roks-da.git
cd openshift-ai-roks-da
```

### 2. Create terraform.tfvars

```hcl
# Required Variables
ibmcloud_api_key    = "your-api-key-here"
region              = "us-south"
resource_group_id   = "your-resource-group-id"
prefix              = "my-openshift-ai"

# Optional: Customize cluster
openshift_version   = "4.15_openshift"
worker_pool_flavor  = "bx2.16x64"
workers_per_zone    = 2
number_of_zones     = 3

# Optional: Customize ODF
odf_cluster_size    = "medium"  # small, medium, or large

# Optional: Enable observability
enable_observability = false
```

### 3. Initialize and Deploy

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy the infrastructure
terraform apply
```

Deployment typically takes **60-90 minutes**.

## Configuration

### Core Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `ibmcloud_api_key` | IBM Cloud API key | - | Yes |
| `region` | IBM Cloud region | `us-south` | Yes |
| `resource_group_id` | Resource group ID | - | Yes |
| `prefix` | Resource name prefix | `openshift-ai` | No |

### VPC Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `create_vpc` | Create new VPC | `true` |
| `number_of_zones` | Number of zones (1-3) | `3` |
| `subnet_cidr_blocks` | CIDR blocks for subnets | `["10.10.10.0/24", ...]` |
| `enable_public_gateway` | Enable public gateway | `true` |

### ROKS Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `openshift_version` | OpenShift version | `4.15_openshift` |
| `worker_pool_flavor` | Worker node flavor | `bx2.16x64` |
| `workers_per_zone` | Workers per zone | `2` |
| `disable_public_service_endpoint` | Disable public endpoint | `false` |

### ODF Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `enable_odf` | Enable ODF | `true` |
| `odf_cluster_size` | ODF size (small/medium/large) | `medium` |
| `odf_billing_type` | Billing type | `advanced` |

### OpenShift AI Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `enable_openshift_ai` | Enable OpenShift AI | `true` |
| `openshift_ai_channel` | Update channel | `stable` |
| `openshift_ai_components` | Components to enable | See below |

#### OpenShift AI Components

```hcl
openshift_ai_components = {
  dashboard              = true   # Web dashboard
  workbenches            = true   # Jupyter notebooks
  data_science_pipelines = true   # Kubeflow Pipelines
  model_serving          = true   # Model serving
  kserve                 = true   # KServe
  model_mesh             = true   # ModelMesh
  ray                    = false  # Ray (optional)
  trustyai               = false  # TrustyAI (optional)
  code_flare             = false  # CodeFlare (optional)
}
```

## Modules

### VPC Module (`modules/vpc/`)
Creates VPC infrastructure including subnets, security groups, and public gateways.

### ROKS Cluster Module (`modules/roks-cluster/`)
Provisions Red Hat OpenShift cluster with configurable worker pools.

### Storage ODF Module (`modules/storage-odf/`)
Installs and configures OpenShift Data Foundation for persistent storage.

### OpenShift AI Module (`modules/openshift-ai/`)
Deploys OpenShift AI operator and configures components.

### Observability Module (`modules/observability/`)
Optional module for IBM Cloud Monitoring and Logging integration.

## Outputs

After successful deployment, Terraform outputs include:

```
cluster_id                  = "cluster-id"
cluster_name                = "my-openshift-ai-cluster"
cluster_endpoint            = "https://c100-e.us-south.containers.cloud.ibm.com:12345"
openshift_ai_dashboard_url  = "https://rhods-dashboard-..."
cluster_access_instructions = "Instructions to access cluster"
```

## Cost Estimation

### Monthly Cost Breakdown (Approximate)

| Component | Configuration | Monthly Cost (USD) |
|-----------|--------------|-------------------|
| VPC Infrastructure | 3 zones, subnets, gateways | $50-100 |
| ROKS Cluster | 6 workers (bx2.16x64) | $2,400-2,800 |
| OpenShift Data Foundation | Medium (2TiB) | $800-1,000 |
| OpenShift AI | Included with ROKS | $0 |
| **Total** | | **~$3,250-3,900/month** |

> **Note**: Costs vary by region and usage. Use the [IBM Cloud Cost Estimator](https://cloud.ibm.com/estimator) for accurate pricing.

## Deployment Guide

### Step 1: Prepare Environment

```bash
# Install IBM Cloud CLI
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh

# Install Terraform
# See: https://developer.hashicorp.com/terraform/downloads

# Install kubectl and oc
# See: https://kubernetes.io/docs/tasks/tools/
```

### Step 2: Configure Variables

Create `terraform.tfvars` with your configuration (see Quick Start).

### Step 3: Deploy

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### Step 4: Access Cluster

```bash
# Log in to IBM Cloud
ibmcloud login --apikey <your-api-key>

# Download cluster config
ibmcloud ks cluster config --cluster <cluster-id>

# Verify access
oc get nodes
```

## Post-Deployment

### Access OpenShift AI Dashboard

1. Get the dashboard URL from Terraform outputs:
   ```bash
   terraform output openshift_ai_dashboard_url
   ```

2. Open the URL in your browser

3. Log in with your OpenShift credentials

### Create Your First Data Science Project

1. In the OpenShift AI dashboard, click **Data Science Projects**
2. Click **Create project**
3. Enter project name and description
4. Click **Create**

### Launch a Jupyter Notebook

1. In your project, click **Workbenches**
2. Click **Create workbench**
3. Select notebook image (e.g., Standard Data Science)
4. Configure resources (CPU, memory, GPU)
5. Click **Create workbench**
6. Wait for workbench to start
7. Click **Open** to access Jupyter

### Deploy a Model

1. Train your model in a notebook
2. Save the model
3. Go to **Models** in your project
4. Click **Deploy model**
5. Configure serving runtime (KServe or ModelMesh)
6. Deploy and test your model

## Troubleshooting

### Cluster Creation Timeout

**Issue**: Cluster creation exceeds timeout

**Solution**: Increase `cluster_ready_timeout` variable:
```hcl
cluster_ready_timeout = 120  # minutes
```

### ODF Installation Fails

**Issue**: ODF add-on fails to install

**Solution**: 
1. Verify worker nodes have sufficient resources
2. Check worker node status: `oc get nodes`
3. Review ODF operator logs: `oc logs -n openshift-storage`

### OpenShift AI Components Not Starting

**Issue**: OpenShift AI components stuck in pending state

**Solution**:
1. Check storage class availability: `oc get sc`
2. Verify ODF is ready: `oc get storagecluster -n openshift-storage`
3. Check pod events: `oc describe pod <pod-name> -n redhat-ods-applications`

### Cannot Access Dashboard

**Issue**: OpenShift AI dashboard URL not accessible

**Solution**:
1. Verify route exists: `oc get route -n redhat-ods-applications`
2. Check ingress: `oc get ingress -A`
3. Verify cluster public endpoint is enabled

## Best Practices

1. **Use Private Endpoints**: For production, consider disabling public endpoints
2. **Enable KMS Encryption**: Use Key Protect or Hyper Protect Crypto Services
3. **Configure Backup**: Set up regular backups for persistent data
4. **Monitor Resources**: Enable observability for production workloads
5. **Use GitOps**: Manage configurations with Git and ArgoCD
6. **Implement RBAC**: Configure proper role-based access control
7. **Regular Updates**: Keep OpenShift and operators updated

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Support

For issues and questions:

- **GitHub Issues**: [Create an issue](https://github.com/your-org/openshift-ai-roks-da/issues)
- **IBM Cloud Support**: [Open a support case](https://cloud.ibm.com/unifiedsupport/cases/form)
- **Red Hat Support**: [Red Hat Customer Portal](https://access.redhat.com/)

## Resources

- [OpenShift AI Documentation](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed)
- [IBM Cloud ROKS Documentation](https://cloud.ibm.com/docs/openshift)
- [OpenShift Data Foundation](https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation)
- [Terraform IBM Provider](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs)

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

**Maintained by**: IBM Cloud Architecture Team  
**Version**: 1.0.0  
**Last Updated**: 2026-03-12# Custom-DA-IBM-Cloud

# OpenShift AI on IBM Cloud ROKS - Deployable Architecture Structure

## Folder Structure

```
openshift-ai-roks-da/
├── README.md                          # Main documentation
├── metadata.json                      # IBM Cloud Private Catalog metadata
├── version.tf                         # Terraform and provider versions
├── main.tf                            # Root module orchestration
├── variables.tf                       # Input variables
├── outputs.tf                         # Output values
├── .gitignore                         # Git ignore file
├── package.sh                         # Script to create .tgz for Private Catalog
│
├── modules/                           # Reusable modules
│   ├── vpc/                          # VPC infrastructure module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── roks-cluster/                 # ROKS cluster module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── storage-odf/                  # OpenShift Data Foundation module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── openshift-ai/                 # OpenShift AI operator module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── templates/
│   │       ├── datasciencecluster.yaml.tpl
│   │       └── subscription.yaml.tpl
│   │
│   └── observability/                # Optional monitoring module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
│
├── examples/                          # Example implementations
│   ├── basic/                        # Basic deployment example
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   └── complete/                     # Complete deployment with all features
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
│
└── tests/                            # Test configurations (optional)
    └── pr_test.go
```

## Module Descriptions

### 1. VPC Module (`modules/vpc/`)
- Creates IBM Cloud VPC
- Configures subnets across multiple zones
- Sets up Public Gateway for internet access
- Configures Security Groups
- Creates Network ACLs

### 2. ROKS Cluster Module (`modules/roks-cluster/`)
- Deploys Red Hat OpenShift on IBM Cloud
- Configures worker pools across zones
- Sets up cluster networking
- Configures cluster add-ons
- Enables private/public service endpoints

### 3. Storage ODF Module (`modules/storage-odf/`)
- Installs OpenShift Data Foundation operator
- Configures storage cluster
- Sets up persistent storage classes
- Justification: ODF is chosen over Portworx because:
  - Native OpenShift integration
  - Better support for AI/ML workloads with RWX volumes
  - Integrated with OpenShift AI requirements
  - Cost-effective for cloud-native storage

### 4. OpenShift AI Module (`modules/openshift-ai/`)
- Installs OpenShift AI operator via OLM
- Configures DataScienceCluster CR
- Enables notebook components
- Enables model serving (KServe/ModelMesh)
- Configures dashboard and workbenches

### 5. Observability Module (`modules/observability/`)
- Optional IBM Cloud Monitoring integration
- Optional IBM Cloud Logging integration
- Configures log forwarding
- Sets up metrics collection

## Key Features

1. **High Availability**: Multi-zone deployment for VPC and ROKS
2. **Security**: Network isolation, security groups, private endpoints
3. **Scalability**: Configurable worker pools and storage
4. **Compliance**: Follows IBM Cloud best practices
5. **Modularity**: Reusable modules for different scenarios
6. **Production-Ready**: Includes monitoring and logging options

## Storage Decision: ODF vs Portworx

**Selected: OpenShift Data Foundation (ODF)**

Reasons:
- Native Red Hat/OpenShift solution
- Better integration with OpenShift AI
- Supports RWX (ReadWriteMany) for shared notebook storage
- Lower operational complexity
- Cost-effective for AI/ML workloads
- Included in OpenShift subscription
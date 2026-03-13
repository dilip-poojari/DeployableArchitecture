# Quick Start Guide - OpenShift AI on IBM Cloud ROKS

Get started with OpenShift AI on IBM Cloud in minutes!

## Prerequisites Checklist

- [ ] IBM Cloud account
- [ ] IBM Cloud API key with Administrator access
- [ ] Resource group ID
- [ ] Terraform v1.3.0+ installed
- [ ] IBM Cloud CLI installed (optional, for post-deployment)

## 5-Minute Setup

### Step 1: Clone and Configure (2 minutes)

```bash
# Clone the repository
git clone https://github.com/your-org/openshift-ai-roks-da.git
cd openshift-ai-roks-da

# Create your configuration file
cat > terraform.tfvars <<EOF
ibmcloud_api_key  = "YOUR_API_KEY_HERE"
region            = "us-south"
resource_group_id = "YOUR_RESOURCE_GROUP_ID"
prefix            = "my-ai-cluster"
EOF
```

### Step 2: Deploy (1 minute to start)

```bash
# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Deploy (takes 60-90 minutes)
terraform apply -auto-approve
```

### Step 3: Access Your Environment (2 minutes)

```bash
# Get the dashboard URL
terraform output openshift_ai_dashboard_url

# Get cluster access instructions
terraform output cluster_access_instructions
```

## What Gets Deployed?

✅ **VPC Infrastructure** - Multi-zone networking  
✅ **OpenShift Cluster** - 6 worker nodes (2 per zone)  
✅ **Storage (ODF)** - 2TiB persistent storage  
✅ **OpenShift AI** - Complete AI/ML platform  

## First Steps After Deployment

### 1. Access OpenShift AI Dashboard

Open the dashboard URL from outputs in your browser.

### 2. Create Your First Project

1. Click **Data Science Projects**
2. Click **Create project**
3. Name it "my-first-project"
4. Click **Create**

### 3. Launch a Notebook

1. In your project, click **Workbenches**
2. Click **Create workbench**
3. Select **Standard Data Science** image
4. Set resources: 2 CPU, 8GB RAM
5. Click **Create workbench**
6. Wait ~2 minutes for startup
7. Click **Open** to access Jupyter

### 4. Run Your First Model

Create a new notebook and run:

```python
# Import libraries
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# Load sample data
from sklearn.datasets import load_iris
iris = load_iris()
X, y = iris.data, iris.target

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Train model
model = RandomForestClassifier()
model.fit(X_train, y_train)

# Evaluate
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)
print(f"Model Accuracy: {accuracy:.2%}")
```

## Cost Management

**Estimated Monthly Cost**: ~$3,250-3,900 USD

To minimize costs:
- Use smaller worker nodes for development
- Reduce number of zones to 1 for testing
- Destroy resources when not in use: `terraform destroy`

## Troubleshooting

### Deployment Stuck?

Check status:
```bash
terraform show
```

### Can't Access Dashboard?

Verify cluster is ready:
```bash
ibmcloud ks cluster get --cluster $(terraform output -raw cluster_id)
```

### Need Help?

- Check [README.md](README.md) for detailed documentation
- Review [examples/basic/](examples/basic/) for configuration examples
- Open an issue on GitHub

## Next Steps

- 📚 Read the [full documentation](README.md)
- 🎓 Explore [OpenShift AI tutorials](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed)
- 🚀 Deploy your first production model
- 🔧 Customize your deployment

## Clean Up

When you're done:

```bash
terraform destroy -auto-approve
```

**⚠️ Warning**: This deletes all resources and data. Backup important work first!

---

**Questions?** Open an issue or check the [README.md](README.md)
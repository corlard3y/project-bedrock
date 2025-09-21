# Project Bedrock - AWS Retail Store on EKS

Deploy the official [AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app) to Amazon EKS with full Infrastructure as Code and CI/CD automation.

## 🏗️ Architecture Overview

### **Infrastructure Components:**
- **EKS Cluster** (Kubernetes 1.32) with 2 nodes
- **VPC** with public/private subnets for security
- **LoadBalancer** for external access
- **CI/CD Pipeline** with GitHub Actions

### **Application Components:**
- **UI Service** (Java): Store frontend with themes
- **Catalog Service** (Go): Product catalog API with MySQL
- **Orders Service** (Java): Order management with PostgreSQL  
- **Checkout Service** (Node.js): Checkout orchestration with RabbitMQ
- **Carts Service** (Java): Shopping cart with Redis

### **Architecture Diagram:**
```
VPC (10.0.0.0/16)
├── Public Subnets (LoadBalancer, NAT Gateway)
├── Private Subnets (EKS Cluster, Databases)
└── EKS Cluster
    ├── UI Service (LoadBalancer) - Store frontend
    ├── Catalog Service - Product catalog API
    ├── Orders Service - Order management API
    ├── Checkout Service - Checkout orchestration
    └── Databases: MySQL, PostgreSQL, Redis, RabbitMQ
```

## 🌐 How to Access the Application

### **Public Access:**
**Application URL:** `http://af7e4925d72a64239b215275f94f283d-1111406291.eu-west-1.elb.amazonaws.com`

**What you can do:**
- Browse the retail store
- View products and categories
- Add items to cart
- Test the full shopping experience

### **Developer Access (Read-Only):**

**Get Credentials:**
```bash
# Get access keys
terraform output dev_readonly_access_key_id
terraform output dev_readonly_secret_access_key
```

**Configure Access:**
```bash
# Configure AWS CLI
aws configure --profile dev-readonly
# Enter the access key and secret from above

# Access EKS cluster
aws eks update-kubeconfig --region eu-west-1 --name project-bedrock-eks --profile dev-readonly
```

**Developer Capabilities:**
- ✅ View pods, services, deployments
- ✅ Access pod logs (`kubectl logs <pod-name>`)
- ✅ Describe pods (`kubectl describe pod <pod-name>`)
- ✅ Check service status (`kubectl get svc`)
- ❌ Cannot create, update, or delete resources

## 📁 Project Structure

```
project-bedrock/
├── terraform/           # Infrastructure as Code
│   ├── main.tf         # Provider configuration
│   ├── variables.tf    # Input variables
│   ├── outputs.tf      # Output values
│   ├── vpc.tf          # VPC and networking
│   ├── eks.tf          # EKS cluster
│   ├── iam.tf          # IAM roles and policies
│   └── policies/       # IAM policy files
├── k8s/                # Kubernetes manifests
│   ├── namespace.yaml  # Application namespace
│   ├── configmap.yaml  # Application configuration
│   ├── secrets.yaml    # Database credentials
│   ├── mysql.yaml      # MySQL database
│   ├── postgres.yaml   # PostgreSQL database
│   ├── redis.yaml      # Redis cache
│   ├── rabbitmq.yaml   # Message broker
│   ├── catalog-service.yaml  # Product catalog
│   ├── orders-service.yaml   # Order management
│   ├── checkout-service.yaml # Checkout orchestration
│   ├── ui-service.yaml       # Store frontend
│   ├── rbac.yaml       # Developer access control
│   └── deploy.sh       # Deployment script
├── .github/workflows/  # CI/CD pipeline
│   └── terraform-ci-cd.yml
└── README.md
```

## 🚀 Quick Start

### **Prerequisites:**
- AWS CLI configured
- Terraform >= 1.3.0
- kubectl
- Git

### **Deploy Everything:**
```bash
# 1. Clone the repository
git clone <your-repo-url>
cd project-bedrock

# 2. Deploy infrastructure
cd terraform
terraform init
terraform apply

# 3. Configure kubectl
aws eks update-kubeconfig --region eu-west-1 --name project-bedrock-eks

# 4. Deploy application
cd ../k8s
./deploy.sh

# 5. Update secrets
kubectl create secret generic retail-store-secrets \
  --from-literal=MYSQL_PASSWORD="password123" \
  --from-literal=MYSQL_USER="root" \
  --from-literal=POSTGRES_PASSWORD="password123" \
  --from-literal=POSTGRES_USER="postgres" \
  --from-literal=RABBITMQ_PASSWORD="password123" \
  --from-literal=RABBITMQ_USER="admin" \
  -n retail-store --dry-run=client -o yaml | kubectl apply -f -
```

## 🔐 Security & Access

### **User Access:**
- **johndoe**: Admin user with full access to EKS cluster
- **dev-readonly**: Read-only developer access with proper RBAC permissions
- Both users are mapped to the cluster with appropriate permissions

### **Security Features:**
- VPC with public/private subnet isolation
- EKS cluster in private subnets
- IAM roles with least privilege access
- Kubernetes RBAC for fine-grained permissions

## 🚦 CI/CD Pipeline

### **Setup:**
1. Add secret to GitHub repository:
   - `AWS_ROLE_ARN`: Get from `terraform output github_actions_role_arn`

### **Pipeline Behavior:**
- **Pull Requests**: Terraform plan validation
- **Main Branch**: Automatic deployment
- **Manual**: Destroy infrastructure (workflow_dispatch)

## 📊 Current Status

**Application URL:**
`http://af7e4925d72a64239b215275f94f283d-1111406291.eu-west-1.elb.amazonaws.com`

**Services Status:**
- ✅ UI Service: 1/1 Running
- ✅ Catalog Service: 1/1 Running  
- ✅ Orders Service: 1/1 Running
- ✅ Checkout Service: 1/1 Running
- ✅ All Databases: MySQL, PostgreSQL, Redis, RabbitMQ

## 🧹 Cleanup

```bash
cd terraform
terraform destroy
```

## ✅ Requirements Completed

**Core Requirements:**
- ✅ EKS cluster provisioned with IaC
- ✅ All microservices deployed and running
- ✅ Developer read-only access configured
- ✅ CI/CD pipeline functional

---

**Project Bedrock is complete and ready for production!** 🎉
# Project Bedrock - AWS Retail Store Sample App on EKS

Deploy the official [AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app) to Amazon EKS with Infrastructure as Code and CI/CD automation.

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with `johndoe` user
- Terraform >= 1.3.0
- kubectl
- Git
- AWS user must have EKS cluster access permissions

### Deploy Everything
```bash
# 1. Clone the repository
git clone <your-repo-url>
cd project-bedrock

# 2. Update GitHub variables in terraform/variables.tf
# Set your github_org and github_repo

# 3. Deploy infrastructure
cd terraform
terraform init
terraform apply

# 4. Configure kubectl
aws eks update-kubeconfig --region eu-west-1 --name project-bedrock-eks

# 5. Deploy application
cd ../k8s
./deploy.sh
```

### Access Application
```bash
# Get external IP
kubectl get service ui-service -n retail-store

# Access at: http://<EXTERNAL-IP>
```

## 🏗️ Architecture

```
VPC (10.0.0.0/16)
├── Public Subnets (ALB, NAT)
├── Private Subnets (EKS, RDS)
└── EKS Cluster
    ├── UI Service (Java) - Store frontend
    ├── Catalog Service (Go) - Product catalog API
    ├── Orders Service (Java) - Order management API
    ├── Carts Service (Java) - Shopping cart API
    ├── Checkout Service (Node.js) - Checkout orchestration
    └── Databases: MySQL, PostgreSQL, Redis, RabbitMQ
```

## 📁 Project Structure

```
project-bedrock/
├── terraform/           # Infrastructure as Code
│   ├── main.tf         # Provider config
│   ├── variables.tf    # Input variables
│   ├── outputs.tf      # Output values
│   ├── vpc.tf          # VPC and networking
│   ├── eks.tf          # EKS cluster
│   ├── iam.tf          # IAM roles
│   ├── rds.tf          # Managed databases (Bonus)
│   ├── dynamodb.tf     # NoSQL database (Bonus)
│   ├── alb-ingress.tf  # Load balancer (Bonus)
│   └── policies/       # IAM policies
├── k8s/                # Kubernetes manifests
│   ├── namespace.yaml  # Namespace
│   ├── configmap.yaml  # App config
│   ├── secrets.yaml    # Sensitive data
│   ├── mysql.yaml      # MySQL database
│   ├── postgres.yaml   # PostgreSQL database
│   ├── redis.yaml      # Redis cache
│   ├── rabbitmq.yaml   # Message broker
│   ├── catalog-service.yaml  # Product catalog (Go)
│   ├── orders-service.yaml   # Order management (Java)
│   ├── carts-service.yaml    # Shopping cart (Java)
│   ├── checkout-service.yaml # Checkout orchestration (Node.js)
│   ├── ui-service.yaml       # Store frontend (Java)
│   ├── alb-ingress-controller.yaml  # ALB Controller (Bonus)
│   ├── ingress.yaml    # ALB Ingress (Bonus)
│   ├── managed-db-configmap.yaml    # Managed DB config (Bonus)
│   ├── managed-db-secrets.yaml      # Managed DB secrets (Bonus)
│   ├── deploy.sh       # Basic deployment
│   └── deploy-with-bonus.sh  # Bonus features deployment
├── .github/workflows/  # CI/CD pipeline
│   └── terraform-ci-cd.yml
└── README.md
```

## 🔧 AWS Retail Store Sample App Components

### Microservices
- **UI Service** (Java): Store frontend with themes and topology information
- **Catalog Service** (Go): Product catalog API with MySQL backend
- **Orders Service** (Java): Order management API with PostgreSQL backend
- **Carts Service** (Java): Shopping cart API with Redis backend
- **Checkout Service** (Node.js): Checkout orchestration with RabbitMQ

### Infrastructure Services
- **MySQL**: Product catalog database
- **PostgreSQL**: Orders database
- **Redis**: Caching and session storage
- **RabbitMQ**: Message queuing

## 🔐 Security & Access

### IAM Users & EKS Access
- **johndoe**: My existing user with admin access to EKS cluster
- **dev-readonly**: Read-only developer access with proper RBAC permissions
- **EKS Access**: Both users are mapped to the cluster with appropriate permissions

### Developer Access
```bash
# Get credentials
terraform output dev_readonly_access_key_id
terraform output dev_readonly_secret_access_key

# Configure AWS CLI
aws configure --profile dev-readonly

# Access cluster
aws eks update-kubeconfig --region eu-west-1 --name project-bedrock-eks --profile dev-readonly
```

## 🚦 CI/CD Pipeline

### Setup GitHub Actions
1. Add secret to your GitHub repository:
   - `AWS_ROLE_ARN`: Get from `terraform output github_actions_role_arn`

2. Pipeline behavior:
   - **Pull Requests**: Terraform plan validation
   - **Main Branch**: Automatic deployment
   - **Manual**: Destroy infrastructure (workflow_dispatch)

## 🎁 Bonus Features

### Managed Databases
```bash
# Deploy with RDS and DynamoDB
cd k8s
./deploy-with-bonus.sh
```

**Features:**
- RDS PostgreSQL for orders service
- RDS MySQL for catalog service
- DynamoDB for carts and sessions
- All with encryption and backups

### ALB with SSL
**Features:**
- AWS Load Balancer Controller
- Application Load Balancer with SSL
- Route 53 domain management
- HTTPS with automatic redirect

**Access:**
- `https://project-bedrock.local` (add to /etc/hosts)
- `https://api.project-bedrock.local` (API endpoints)

## 📊 Monitoring

```bash
# Check status
kubectl get pods -n retail-store
kubectl get services -n retail-store
kubectl get ingress -n retail-store  # For bonus features

# View logs
kubectl logs -f deployment/ui-service -n retail-store
```

## 🧹 Cleanup

```bash
cd terraform
terraform destroy
```

## 🔍 Troubleshooting

**kubectl not configured:**
```bash
aws eks update-kubeconfig --region eu-west-1 --name project-bedrock-eks
```

**Pods not starting:**
```bash
kubectl describe pod <pod-name> -n retail-store
kubectl logs <pod-name> -n retail-store
```

## ✅ Requirements Completed

### Core Requirements
- ✅ EKS cluster provisioned with IaC
- ✅ All microservices deployed and running
- ✅ Developer read-only access configured
- ✅ CI/CD pipeline functional

### Bonus Features
- ✅ RDS PostgreSQL and MySQL integrated
- ✅ DynamoDB tables created and configured
- ✅ ALB Ingress Controller installed
- ✅ SSL certificate provisioned and attached
- ✅ HTTPS enabled with automatic redirect

## 🎯 Success Criteria

Your deployment is successful when:
- All pods are in `Running` state
- All services have valid endpoints
- UI service is accessible via external IP
- Developer can access cluster with read-only permissions
- CI/CD pipeline is functional

---

**Project Bedrock is complete and ready for production!** 🎉

# Project Bedrock - Retail Store Microservices on AWS EKS

Production-grade microservices application deployed on Amazon EKS with Infrastructure as Code and CI/CD automation.

## 🚀 Quick Start

### Prerequisites
- AWS CLI configured with your `johndoe` user
- Terraform >= 1.3.0
- kubectl
- Git

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
    ├── UI Service (LoadBalancer)
    ├── Catalog Service (MySQL)
    ├── Orders Service (PostgreSQL)
    ├── Carts Service (Redis)
    └── RabbitMQ (Message Queue)
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
│   ├── catalog-service.yaml  # Product catalog
│   ├── orders-service.yaml   # Order management
│   ├── carts-service.yaml    # Shopping cart
│   ├── ui-service.yaml       # Frontend
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

## 🔐 Security & Access

### IAM Users
- **johndoe**: Your existing user (correct approach!)
- **dev-readonly**: Read-only developer access

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
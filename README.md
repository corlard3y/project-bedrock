# Project Bedrock - AWS Retail Store on EKS

I deployed the official [AWS Retail Store Sample App](https://github.com/aws-containers/retail-store-sample-app) to Amazon EKS with full Infrastructure as Code and CI/CD automation.

## 🚀 What I Built

**Core Application:**
- **UI Service**: Store frontend with themes
- **Catalog Service**: Product catalog API with MySQL
- **Orders Service**: Order management with PostgreSQL
- **Checkout Service**: Checkout orchestration with RabbitMQ
- **Carts Service**: Shopping cart with Redis

**Infrastructure:**
- EKS cluster (Kubernetes 1.32) with 2 nodes
- VPC with public/private subnets
- CI/CD pipeline with GitHub Actions

## 🏗️ Architecture

```
VPC (10.0.0.0/16)
├── Public Subnets (ALB, NAT)
├── Private Subnets (EKS, RDS)
└── EKS Cluster
    ├── UI Service (LoadBalancer) - Store frontend
    ├── Catalog Service - Product catalog API
    ├── Orders Service - Order management API
    ├── Checkout Service - Checkout orchestration
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
│   ├── checkout-service.yaml # Checkout orchestration
│   ├── ui-service.yaml       # Store frontend
│   ├── rbac.yaml       # Developer access
│   └── deploy.sh       # Deployment script
├── .github/workflows/  # CI/CD pipeline
│   └── terraform-ci-cd.yml
└── README.md
```

## 🔐 Security & Access

**My Access:**
- **johndoe**: My existing user with admin access to EKS cluster
- **dev-readonly**: Read-only developer access with proper RBAC permissions
- Both users are mapped to the cluster with appropriate permissions

**Developer Access:**
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

**Setup:**
1. Add secret to GitHub repository:
   - `AWS_ROLE_ARN`: Get from `terraform output github_actions_role_arn`

**Pipeline behavior:**
- **Pull Requests**: Terraform plan validation
- **Main Branch**: Automatic deployment
- **Manual**: Destroy infrastructure (workflow_dispatch)


## 📊 Current Status

**Application URL:**
`http://af7e4925d72a64239b215275f94f283d-1111406291.eu-west-1.elb.amazonaws.com`

**All Services Running:**
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

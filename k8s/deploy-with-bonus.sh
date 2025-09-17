#!/bin/bash

# Project Bedrock - Kubernetes Deployment Script with Bonus Features
# This script deploys the retail store microservices to EKS with managed databases and ALB

set -e

echo "🚀 Starting Project Bedrock deployment with bonus features..."

# Check if kubectl is configured
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ kubectl is not configured or cluster is not accessible"
    echo "Please run: aws eks update-kubeconfig --region eu-west-1 --name project-bedrock-eks"
    exit 1
fi

# Create namespace first
echo "📦 Creating namespace..."
kubectl apply -f namespace.yaml

# Apply configurations
echo "⚙️  Applying configurations..."
kubectl apply -f managed-db-configmap.yaml
kubectl apply -f managed-db-secrets.yaml
kubectl apply -f rbac.yaml

# Deploy ALB Ingress Controller
echo "🌐 Deploying AWS Load Balancer Controller..."
kubectl apply -f alb-ingress-controller.yaml

# Wait for ALB controller to be ready
echo "⏳ Waiting for ALB controller to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/aws-load-balancer-controller -n kube-system

# Deploy microservices (using managed databases)
echo "🔧 Deploying retail store microservices with managed databases..."
kubectl apply -f catalog-service.yaml
kubectl apply -f orders-service.yaml
kubectl apply -f carts-service.yaml
kubectl apply -f checkout-service.yaml
kubectl apply -f ui-service.yaml

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/catalog-service -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/orders-service -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/carts-service -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/checkout-service -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/ui-service -n retail-store

# Deploy Ingress
echo "🔗 Deploying Ingress with SSL..."
kubectl apply -f ingress.yaml

# Wait for ALB to be provisioned
echo "⏳ Waiting for ALB to be provisioned..."
echo "This may take a few minutes..."

# Get ALB information
echo "📊 Getting ALB information..."
kubectl get ingress retail-store-ingress -n retail-store

echo "✅ Deployment completed successfully!"
echo ""
echo "📊 Deployment Status:"
kubectl get pods -n retail-store
echo ""
echo "🌐 Services:"
kubectl get services -n retail-store
echo ""
echo "🔗 Ingress:"
kubectl get ingress -n retail-store
echo ""
echo "🎉 Your application is now accessible via:"
echo "   - HTTP: http://project-bedrock.local"
echo "   - HTTPS: https://project-bedrock.local"
echo "   - API: https://api.project-bedrock.local"
echo ""
echo "📝 Note: Add the following to your /etc/hosts file:"
echo "   <ALB_DNS_NAME> project-bedrock.local"
echo "   <ALB_DNS_NAME> api.project-bedrock.local"

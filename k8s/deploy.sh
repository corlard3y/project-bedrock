#!/bin/bash

# Project Bedrock - Kubernetes Deployment Script
# This script deploys the retail store microservices to EKS

set -e

echo "🚀 Starting Project Bedrock deployment..."

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
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml
kubectl apply -f rbac.yaml

# Deploy databases
echo "🗄️  Deploying databases..."
kubectl apply -f mysql.yaml
kubectl apply -f postgres.yaml
kubectl apply -f redis.yaml
kubectl apply -f rabbitmq.yaml

# Wait for databases to be ready
echo "⏳ Waiting for databases to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mysql -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/postgres -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/redis -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/rabbitmq -n retail-store

# Deploy microservices
echo "🔧 Deploying retail store microservices..."
kubectl apply -f catalog-service.yaml
kubectl apply -f orders-service.yaml
kubectl apply -f checkout-service.yaml
kubectl apply -f ui-service.yaml

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/catalog-service -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/orders-service -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/checkout-service -n retail-store
kubectl wait --for=condition=available --timeout=300s deployment/ui-service -n retail-store

echo "✅ Deployment completed successfully!"
echo ""
echo "📊 Deployment Status:"
kubectl get pods -n retail-store
echo ""
echo "🌐 Services:"
kubectl get services -n retail-store
echo ""
echo "🔗 To access the UI service, get the external IP:"
echo "kubectl get service ui-service -n retail-store"

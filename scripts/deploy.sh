#!/bin/bash
# Generic deployment script
# Usage: ./deploy.sh [environment] [version]

set -e

ENVIRONMENT=${1:-staging}
VERSION=${2:-latest}
APP_NAME=${APP_NAME:-$(basename $(pwd))}
NAMESPACE=${NAMESPACE:-default}

echo "🚀 Deploying $APP_NAME version $VERSION to $ENVIRONMENT environment"

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|production)$ ]]; then
    echo "❌ Invalid environment: $ENVIRONMENT"
    echo "Valid environments: dev, staging, production"
    exit 1
fi

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl."
    exit 1
fi

# Check if namespace exists, create if not
if ! kubectl get namespace "$NAMESPACE" &> /dev/null; then
    echo "📦 Creating namespace: $NAMESPACE"
    kubectl create namespace "$NAMESPACE"
fi

# Set image tag
IMAGE_TAG="${IMAGE_NAME:-$APP_NAME}:${VERSION}"

# Update deployment
echo "📝 Updating deployment..."
kubectl set image deployment/$APP_NAME \
    $APP_NAME=$IMAGE_TAG \
    -n $NAMESPACE

# Wait for rollout
echo "⏳ Waiting for rollout..."
kubectl rollout status deployment/$APP_NAME -n $NAMESPACE --timeout=5m

# Verify deployment
echo "✅ Verifying deployment..."
kubectl get pods -n $NAMESPACE -l app=$APP_NAME

echo "🎉 Deployment completed successfully!"

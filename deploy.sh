#!/bin/bash

set -e

# Config
GITHUB_USER="mokadi-suryaprasad"
REPO_NAME="react-project"
CLONE_DIR="gold"
NAMESPACE="react-nginx"

# Use SSH URL for cloning (no username/password prompt if SSH key setup is done)
REPO_URL="git@github.com:${GITHUB_USER}/${REPO_NAME}.git"

echo "📥 Removing old clone directory if it exists..."
rm -rf "$CLONE_DIR"

echo "📥 Cloning repo into '$CLONE_DIR' using SSH (no password prompt)..."
git clone "$REPO_URL" "$CLONE_DIR"

echo "📁 Changing directory to '$CLONE_DIR'..."
cd "$CLONE_DIR"

echo "📦 Applying Kubernetes manifest files in namespace '$NAMESPACE'..."
microk8s kubectl apply -n "$NAMESPACE" -f kubernetes-manifestfiles/

echo "✅ Deployment manifests applied successfully."

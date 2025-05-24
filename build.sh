#!/bin/bash

set -e  # Exit immediately on error

# Clean up Docker system (use with caution)
docker system prune -a -f

# Prepare build directory
rm -rf gold
mkdir gold
cd gold

# Clone project repo
git clone https://github.com/mokadi-suryaprasad/react-project.git
cd react-project

# Get latest commit ID
git_commit=$(git rev-parse HEAD)

# -------------------------------------
# React build step
# -------------------------------------
echo "[INFO] Installing dependencies and building React app..."
sudo npm install react-scripts
npm install
npm run build

# Set permissions (optional)
sudo chmod -R 777 build

# Upload build folder to GCS (in a dated folder)
current_date=$(date +%d%m%Y)
gsutil -m cp -r build "gs://buildartifactorydemo/${current_date}/build"

# Build and tag Docker image
docker build -t suryaprasad9773/react-nginx:$git_commit -f golddockerfile .

# Trivy Scan
# -------------------------------------
echo "[INFO] Running Trivy image scan..."
trivy image --exit-code 1 --severity CRITICAL suryaprasad9773/react-nginx:$git_commit || {
    echo "❌ Trivy scan failed due to HIGH or CRITICAL vulnerabilities."
    exit 1
}

# Push image to DockerHub (already logged in)
docker push suryaprasad9773/react-nginx:$git_commit

# -------------------------------------
# Update Helm chart repo values.yaml and push changes
# -------------------------------------

rm -rf helm-chart
git clone https://github.com/mokadi-suryaprasad/helm-chart.git
cd helm-chart

# Update values.yaml tag with the new git commit
sed -i "s/^  tag: .*/  tag: $git_commit/" values.yaml

# Git commit and push
git config user.email "msuryaprasad11@gmail.com"
git config user.name "Mokadi Surya Prasad"
git add values.yaml
git commit -m "chore: update image tag to $git_commit"
git push origin main

echo "✅ Deployment and Helm chart values.yaml update completed with commit ID: $git_commit"


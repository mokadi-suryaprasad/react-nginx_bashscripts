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

# Push image to DockerHub (already logged in)
docker push suryaprasad9773/react-nginx:$git_commit

# Optional: also tag as latest
docker tag suryaprasad9773/react-nginx:$git_commit suryaprasad9773/react-nginx:latest
docker push suryaprasad9773/react-nginx:latest

# Save commit ID and upload to GCS (already authenticated)
echo $git_commit > new_value.txt
gsutil cp new_value.txt gs://gitcommitids/new_value.txt

# Cleanup
rm new_value.txt

echo "✅ Deployment completed successfully with commit ID: $git_commit"

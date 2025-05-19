#!/bin/bash
set -euo pipefail

# WARNING: Deleting all Docker images is not recommended in most cases!
sudo docker rmi -f $(sudo docker images -q) || true

# WARNING: Removing entire 'gold' directory can cause data loss if not intended!
sudo rm -rf gold || true

sudo mkdir -p gold
cd gold/

sudo git clone https://github.com/mokadi-suryaprasad/react-project.git
cd react-project/

sudo docker build -t react-nginx -f golddockerfile .

# Tag the image with your Docker Hub username
sudo docker tag react-nginx:latest suryaprasad9773/react-nginx:latest

# Push to Docker Hub (make sure you logged in with `docker login`)
sudo docker push suryaprasad9773/react-nginx:latest

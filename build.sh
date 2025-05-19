#!/bin/bash

set -e

# -------- CONFIG --------
DOCKER_USERNAME="suryaprasad9773"        # Docker Hub username
REPO_NAME="react-app"
IMAGE_NAME="react-nginx"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
IMAGE_TAG="$TIMESTAMP"
CLONE_DIR="$HOME/gold"
REPO_DIR="$CLONE_DIR/react-project"
GITHUB_USER="mokadi-suryaprasad"
GIT_REPO="https://github.com/mokadi-suryaprasad/react-project.git"
DOCKERFILE="golddockerfile"
DEPLOYMENT_FILE="$REPO_DIR/kubernetes-manifestfiles/react-deployment.yaml"
BRANCH="main"
# ------------------------

echo "📁 Checking source code directory..."
if [ -d "$REPO_DIR/.git" ]; then
    echo "📂 Directory exists. Pulling latest changes..."
    cd "$REPO_DIR"
    git pull origin "$BRANCH"
else
    echo "📥 Cloning Git repository..."
    mkdir -p "$CLONE_DIR"
    cd "$CLONE_DIR"
    git clone "$GIT_REPO"
    cd react-project
fi

echo "🐳 Building Docker image without cache..."
docker build --no-cache -t "$IMAGE_NAME" -f "$DOCKERFILE" .

DOCKER_IMAGE="$DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"

echo "🏷️ Tagging image as: $DOCKER_IMAGE"
docker tag "$IMAGE_NAME" "$DOCKER_IMAGE"

echo "📤 Pushing image to Docker Hub..."
docker push "$DOCKER_IMAGE"

echo "🔍 Getting image digest..."
DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' "$DOCKER_IMAGE" || echo "$DOCKER_IMAGE")

echo "✅ Image pushed: $DIGEST"

echo "📝 Updating Kubernetes deployment with new image tag..."
echo "DEBUG: Deployment file path is $DEPLOYMENT_FILE"
if [ ! -f "$DEPLOYMENT_FILE" ]; then
  echo "❌ ERROR: Deployment file not found at $DEPLOYMENT_FILE"
  exit 1
fi

# More specific image update to avoid replacing unintended lines
sed -i.bak "s|image: $DOCKER_USERNAME/$IMAGE_NAME:.*|image: $DOCKER_IMAGE|" "$DEPLOYMENT_FILE"

cd "$REPO_DIR"
if git diff --quiet; then
  echo "No changes detected in deployment manifest. Skipping commit."
else
  git add "$DEPLOYMENT_FILE"
  git commit -m "Updated deployment image to $IMAGE_TAG"
  git push origin "$BRANCH"
fi

echo "✅ Kubernetes deployment manifest updated and pushed successfully."

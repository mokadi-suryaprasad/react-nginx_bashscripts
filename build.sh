#!/bin/bash

# Step 1: Clean up and create a new directory called 'gold'
sudo rm -r gold                     # Remove 'gold' directory if it exists
sudo mkdir gold                      # Create a new 'gold' directory
cd gold/                             # Change directory into 'gold'

# Step 2: Clone the GitHub repository
sudo git clone https://github.com/mokadi-suryaprasad/Gold_Site_Ecommerce.git  # Clone the repository

# Step 3: Get the latest commit hash
cd Gold_Site_Ecommerce/              # Go into the cloned repository folder
git_commit=$(sudo git rev-parse HEAD)  # Get the latest commit hash (shortened version)

# Step 4: Build the Docker image
sudo docker build -t react-nginx:$git_commit -f golddockerfile .  # Build Docker image with commit hash as tag

# Step 5: Tag the Docker image for Docker Hub
sudo docker tag react-nginx:$git_commit suryaprasad9773/react-nginx:$git_commit  # Tag the image for Docker Hub

# Step 6: Push the image to Docker Hub
# Make sure you've already run 'docker login' beforehand to authenticate
sudo docker push suryaprasad9773/react-nginx:$git_commit  # Push the tagged image to Docker Hub

# Step 7: Interact with AWS S3
# Remove the old file from the S3 bucket
aws s3 rm s3://gitcommitids1/new_value.txt

# Create a new 'new_value.txt' file to store the commit hash
sudo touch new_value.txt
sudo chmod 777 new_value.txt
sudo echo $git_commit > new_value.txt  # Write the commit hash to the file

# Upload the new file to AWS S3
aws s3 cp new_value.txt s3://gitcommitids1/  # Upload to S3

# Clean up by removing the temporary file
sudo rm new_value.txt  # Delete 'new_value.txt' locally

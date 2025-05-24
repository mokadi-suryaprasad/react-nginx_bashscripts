#!/bin/bash

set -e  # Exit on error

# Navigate to your Helm chart directory
cd /home/msuryaprasad11/react-chart

# Download old and new commit ID files from GCS
gsutil cp gs://gitcommitids/old_value.txt .
gsutil cp gs://gitcommitids/new_value.txt .

# Read commit IDs
old_value=$(cat old_value.txt)
new_value=$(cat new_value.txt)

# Replace the old commit ID with the new one in values.yaml
sed -i "s/${old_value}/${new_value}/g" values.yaml

# Upgrade the Helm release
helm upgrade react-chart .

# Update the old_value.txt in GCS and clean up
gsutil rm gs://gitcommitids/old_value.txt
echo $new_value > old_value.txt
gsutil cp old_value.txt gs://gitcommitids/

# Clean local temporary files
rm old_value.txt new_value.txt

echo "✅ Helm chart updated from $old_value to $new_value and deployed successfully."

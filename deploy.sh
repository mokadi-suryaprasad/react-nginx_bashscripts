#!/bin/bash

# Step 1: Change directory to where the react-chart project is located
cd /home/ubuntu/react-chart/

# Step 2: Download the old and new values from the S3 bucket
aws s3 cp s3://gitcommitids1/old_value.txt .  # Download old_value.txt
aws s3 cp s3://gitcommitids1/new_value.txt .  # Download new_value.txt

# Step 3: Read the content of the downloaded files into variables
old_value=$(cat old_value.txt)  # Assign old_value from the file
new_value=$(cat new_value.txt)  # Assign new_value from the file

# Step 4: Replace the old value with the new value in values.yaml
sed -i "s/${old_value}/${new_value}/g" values.yaml  # Use sed to replace values

# Step 5: Run the Helm upgrade command to apply the changes
helm upgrade react-chart .  # Upgrade the Helm release with the new configuration

# Step 6: Remove the old_value.txt file from the S3 bucket
aws s3 rm s3://gitcommitids1/old_value.txt  # Delete old_value.txt from S3

# Step 7: Update old_value.txt with the new value
echo $new_value > old_value.txt  # Write the new value to old_value.txt

# Step 8: Upload the updated old_value.txt back to the S3 bucket
aws s3 cp old_value.txt s3://gitcommitids1/  # Upload the new old_value.txt

# Step 9: Remove the old_value.txt and new_value.txt files locally
aws s3 rm s3://gitcommitids1/new_value.txt  # Delete the new_value.txt from S3



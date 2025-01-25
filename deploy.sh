#!/bin/bash
cd /home/ubuntu/react-chart/
aws s3 cp s3://gitcommitids1/old_value.txt .
aws s3 cp s3://gitcommitids1/new_value.txt .
old_value=$(cat old_value.txt)new_value=$(cat new_value.txt)
sed -i "s/${old_value}/${new_value}/g" values.yamlhelm upgrade react-chart .
aws s3 rm s3://gitcommitids1/old_value.txtecho $new_value > old_value.txt
aws s3 cp old_value.txt s3://gitcommitids1/rm old_value.txt new_value.txt


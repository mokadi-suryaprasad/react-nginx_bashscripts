#!/bin/bash
sudo docker container prune -f && sudo docker image prune -a -f && sudo docker volume prune -f && sudo docker network prune -f && sudo docker system prune -a -f
##this above step is not recommned step, i am deleting existing images to save space
sudo rm -r gold
sudo mkdir gold
cd gold/
sudo git clone https://github.com/mokadi-suryaprasad/Gold_Site_Ecommerce.git
cd Gold_Site_Ecommerce/git_commit=$(sudo git rev-parse HEAD)
sudo docker build -t react-nginx:$git_commit -f golddockerfile .
sudo docker tag react-nginx:$git_commit suryaprasad9773/react-nginx:$git_commit ##make sure you did docker login
sudo docker push suryaprasad9773/react-nginx:$git_commit
aws s3 rm s3://gitcommitids1/new_value.txtsudo touch new_value.txt
sudo chmod 777 new_value.txt
sudo echo $git_commit > new_value.txt
aws s3 cp new_value.txt s3://gitcommitids1/
sudo rm new_value.txt

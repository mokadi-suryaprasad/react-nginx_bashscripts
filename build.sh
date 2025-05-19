#!/bin/bash
sudo docker rmi -f $(sudo docker images -q) ##this is not recommned step, i am deleting existing images to save space
sudo rm -r gold ## these steps are not recommened instead you can modify script as shown below
sudo mkdir gold
cd gold/
sudo git clone https://github.com/mokadi-suryaprasad/react-project.git
cd react-project/
sudo docker build -t react-nginx -f golddockerfile .
sudo docker tag react-nginx:latest suryaprasad9773/react-nginx:latest ##make sure you did docker login
sudo docker push rsuryaprasad9773/react-nginx:latest

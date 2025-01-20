#!/bin/bash
pods_id=$(microk8s kubectl get pods -n react-nginx |grep react |awk {'print $1'})
microk8s kubectl delete pod $pods_id -n react-nginx 

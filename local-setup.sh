#!/bin/bash

aws eks update-kubeconfig --region eu-west-2 --name webapp-eks-cluster

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 368155700659.dkr.ecr.eu-west-2.amazonaws.com

docker push 368155700659.dkr.ecr.eu-west-2.amazonaws.com/webapp_ecr
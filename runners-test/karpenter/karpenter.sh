#!/bin/bash

# Tag eks node security group with: "karpenter.sh/discovery = webapp-eks-cluster"

# Update configmap to allow Karpenter Nodes to join cluster
# kubectl edit configmap aws-auth -n kube-system
# Add following group:
# - groups:
#     - system:bootstrappers
#     - system:nodes
#     rolearn: arn:aws:iam::368155700659:role/KarpenterNodeRole-webapp-eks-cluster
#     username: system:node:{{EC2PrivateDNSName}}

# Generate Karpenter manifests
# helm template karpenter oci://public.ecr.aws/karpenter/karpenter --version v0.29.0 --namespace karpenter \
#     --set settings.aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-webapp-eks-cluster \
#     --set settings.aws.clusterName=webapp-eks-cluster \
#     --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::368155700659:role/KarpenterControllerRole-webapp-eks-cluster" > karpenter.yaml

# Create Karpenter CRDs
# kubectl create -f https://raw.githubusercontent.com/aws/karpenter/v0.29.0/pkg/apis/crds/karpenter.sh_provisioners.yaml &&\
# kubectl create -f https://raw.githubusercontent.com/aws/karpenter/v0.29.0/pkg/apis/crds/karpenter.k8s.aws_awsnodetemplates.yaml &&\
# kubectl create -f https://raw.githubusercontent.com/aws/karpenter/v0.29.0/pkg/apis/crds/karpenter.sh_machines.yaml 

# Create namespace, deploy Karpenter and provisioner
kubectl create namespace
kubectl apply -f karpenter.yaml -f provisioner.yml
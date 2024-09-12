## Setup Karpenter

To generate the karpenter manifests from scratch: 

```
helm template karpenter oci://public.ecr.aws/karpenter/karpenter --version v0.29.0 --namespace karpenter \
    --set settings.aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-webapp-eks-cluster \
    --set settings.aws.clusterName=webapp-eks-cluster \
    --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::368155700659:role/KarpenterControllerRole-webapp-eks-cluster" > karpenter.yaml
```

1. Tag eks node security group with: "karpenter.sh/discovery = webapp-eks-cluster"
2. Update configmap to allow Karpenter Nodes to join cluster `kubectl edit configmap aws-auth -n kube-system` 
and add the following: 

```
- groups:
    - system:bootstrappers
    - system:nodes
    rolearn: arn:aws:iam::368155700659:role/KarpenterNodeRole-webapp-eks-cluster
    username: system:node:{{EC2PrivateDNSName}}
```

3. Run the "Deploy Karpenter" pipeline.
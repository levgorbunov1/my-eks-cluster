helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=webapp-eks-cluster \
    --set serviceAccount.create=false \
    --set region=eu-west-2 \
    --set vpcId=$(aws ec2 describe-vpcs --filters "Name=cidr,Values=10.0.0.0/16" --query 'Vpcs[0].VpcId' --output text) \
    --set serviceAccount.name=aws-load-balancer-controller
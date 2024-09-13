# Personal EKS Cluster
- Built an EKS cluster using Terraform; configured VPC for EKS.
- Deployed aws-load-balancer-controller to the cluster to manage Application Load Balancers for Kubernetes ingress.
- Deployed Karpenter to the cluster to enable ephemerality of Kubernetes nodes.
- Configured DNS, using Amazon Route 53 and Terraform, to map the domain name to the load balancer.
- Used ACM for SSL certificate management.
- Deployed WordPress instance to the cluster with a MySQL database.


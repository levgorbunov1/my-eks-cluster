# Personal EKS Cluster
- Built a multi-node EKS cluster using Terraform.
- Deployed aws-load-balancer-controller to the cluster to manage Application Load Balancers for Kubernetes ingress.
- Deployed ebs-csi-driver to dynamically provision EBS volumes.
- Deployed Prometheus and Grafana for observability.
- Deployed Karpenter to the cluster to enable ephemerality of Kubernetes nodes.
- Configured DNS, using Amazon Route 53 and Terraform, to map the domain name to the load balancer; used ACM for SSL certificate management.
- Deployed a WordPress instance to the cluster with a MySQL database.

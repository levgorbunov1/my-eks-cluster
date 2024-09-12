resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public-eu-west-2a.id,
      aws_subnet.private-eu-west-2b.id,
      aws_subnet.public-eu-west-2c.id,
    ]
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

data "tls_certificate" "eks_cluster_certificate" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster_certificate.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks_cluster_certificate.url
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
    aws_subnet.private-eu-west-2b.id
  ]

  remote_access {
    source_security_group_ids = [aws_security_group.eks_security_group.id]
  }

  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 1
  }

  instance_types = ["t3.medium"]
}

resource "aws_security_group" "eks_security_group" {
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true 
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    "karpenter.sh/discovery" = "eks-default-sg"
  }
}

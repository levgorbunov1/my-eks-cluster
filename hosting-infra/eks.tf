resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public-eu-west-2a.id,
      aws_subnet.public-eu-west-2b.id,
      aws_subnet.public-eu-west-2c.id,
    ]
    security_group_ids = [aws_security_group.node_group_sg.id]
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

resource "aws_launch_template" "eks_node_launch_template" {
  instance_type = "t3.small"
  name_prefix   = "${var.node_group_name}-lt-"
  key_name = aws_key_pair.eks_cluster_ssh_key.key_name

  network_interfaces {
    security_groups = [aws_security_group.node_group_sg.id]
    associate_public_ip_address = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    http_put_response_hop_limit = 3
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
    aws_subnet.public-eu-west-2b.id
  ]

  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 2
  }

  launch_template {
    id      = aws_launch_template.eks_node_launch_template.id
    version = "$Latest"
  }

  labels = {
    account = "levg"
  }
}


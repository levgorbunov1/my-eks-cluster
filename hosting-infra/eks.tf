resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-eu-west-2a.id,
      aws_subnet.private-eu-west-2b.id,
      aws_subnet.public-eu-west-2c.id
    ]

    # security_group_ids = [aws_security_group.eks_cluster_security_group.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
   subnet_ids = [
    aws_subnet.private-eu-west-2a.id,
    aws_subnet.private-eu-west-2b.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # remote_access {
  #   source_security_group_ids = [aws_security_group.eks_cluster_security_group.id]
  # }

  instance_types = ["t3.micro"]
}

# resource "aws_security_group" "eks_cluster_security_group" {
#   name        = "eks-cluster-sg"
#   description = "EKS Cluster security group"
#   vpc_id      = aws_vpc.eks_vpc.id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group_rule" "allow_all_traffic_within_group" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   security_group_id = aws_security_group.eks_cluster_security_group.id
#   source_security_group_id = aws_security_group.eks_cluster_security_group.id
# }

# resource "aws_security_group_rule" "allow_control_plane_ingress" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   security_group_id = aws_security_group.eks_cluster_security_group.id
#   cidr_blocks       = ["<control-plane-cidr>"]  # Replace with actual control plane CIDR block
# }
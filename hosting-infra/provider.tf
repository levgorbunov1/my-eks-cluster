terraform {
  backend "s3" {
    acl            = "private"
    bucket         = "webapp-tf-state"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "eu-west-2"
  }
}

provider "aws" {
  region  = "eu-west-2"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
}


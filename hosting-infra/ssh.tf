# resource "aws_key_pair" "eks_cluster_ssh_key" {
#   key_name   = "eks_cluster_ssh_key"
#   public_key = var.public_ssh_key
# }
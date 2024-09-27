variable "region" {
  description = "The AWS region to deploy the EKS cluster in."
  type        = string
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "webapp-eks-cluster"
}

variable "node_group_name" {
  description = "The name of the EKS node group."
  type        = string
  default     = "webapp-eks-node-group"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to be used for access."
  type        = string
  default = "my_eks_cluster_ssh_key"
}

variable "my_ip" {
  description = "my ip address"
  type = string
  default = "0.0.0.0/0"
}
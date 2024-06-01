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
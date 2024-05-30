terraform {
  backend "s3" {
    acl            = "private"
    bucket         = "webapp-tf-state"
    encrypt        = true
    key            = "aws-account/terraform.tfstate"
    region         = "eu-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  required_version = "~> 1.6"
}

provider "aws" {
  region  = "eu-west-2"
}
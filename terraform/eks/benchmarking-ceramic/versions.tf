terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.17"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }

# Ensure s3 and dynamodb tables are already created before apply
  backend "s3" {
    bucket         = "tf-bechmark-state"
    key            = "ceramic.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-bechmark-state-locking"
  }
}
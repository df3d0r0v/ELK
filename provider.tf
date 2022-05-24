terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = var.region
  shared_credentials_file = "/home/ec2-user/.aws/credentials"
}
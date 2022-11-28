terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  shared_credentials_file = "/home/Von/.aws/credentials"
  profile                 = "default"
  region                  = "us-east-1"
}
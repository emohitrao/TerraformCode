terraform {
  required_version = ">= 1.4.6, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}
provider "aws" {
  region = "us-west-2"
}

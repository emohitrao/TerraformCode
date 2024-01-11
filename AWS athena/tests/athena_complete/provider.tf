terraform {
  required_version = ">= 1.4.6, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.2.0"
    }
  }
}

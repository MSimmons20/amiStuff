terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.4"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
}

provider "hcp" {
  
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "remote-tf-backend"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

variable "aws_region" {
}

provider "aws" {
  # access_key and secret_access_key are fetched as the following env variables
  # * AWS_ACCESS_KEY_ID (required)
  # * AWS_SECRET_ACCESS_KEY (required)
  # * AWS_SESSION_TOKEN (only if applicable)
  region = var.aws_region
}

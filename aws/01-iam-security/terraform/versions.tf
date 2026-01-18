terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "cloudsec-lab"
  region  = var.aws_region

  default_tags {
    tags = {
      Project     = "cloud-security-labs"
      ManagedBy   = "Terraform"
      Environment = "lab"
      Owner       = "Greg Lewis"
    }
  }
}

terraform {
  
  cloud {
      organization = "ysugrad"
      workspaces {
        name = "learn-terraform-refresh"
      }
  }
  

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  required_version = ">= 1.1"
}
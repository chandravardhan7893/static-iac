terraform {
  backend "s3" {
    bucket = "stuffnz-terraformstatefile"
    key    = "stuffnz/dev-qa"
    region = "ap-southeast-2"
  }

  required_version = ">= 0.14, < 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0"
    }
  }
}
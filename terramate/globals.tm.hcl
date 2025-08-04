globals {
  project_name = "service"
  aws_region   = "ap-northeast-2"

  name_prefix = "${global.project_name}-${global.env}"
}

generate_hcl "providers.tf" {
  content {
    terraform {
      required_version = ">= 1.5.0"
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
        kubernetes = {
          source  = "hashicorp/kubernetes"
          version = "~> 2.20"
        }
      }
    }

    provider "aws" {
      region = global.aws_region
    }
  }
}
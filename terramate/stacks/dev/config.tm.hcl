generate_hcl "backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket  = "${global.project_name}-state-bucket"
        key     = "${tm_trimprefix(terramate.stack.path.relative, "stacks/")}/${tm_basename(terramate.stack.path.relative)}.tfstate"
        region  = global.aws_region
        encrypt = true
      }
    }
  }
}

globals {
  env      = "dev"
  eks_name = "${global.name_prefix}-eks"

  # Tags 중 Description 항목은 개별 리소스에서 직접 작성한다.
  # additional_tags = {
  #   Description = "Dev VPC attach_subnet_1"
  # }
  tags = {
    Project     = "service"
    Environment = "${global.env}"
    Owner       = "DevOps"
    Maintainer  = "Manager"
  }

  enable_kubectl = false
}

sharing_backend "network" {
  type     = terraform
  filename = "network_sharing_generated.tf"
  command  = ["terraform", "output", "-json"]
}

sharing_backend "iam" {
  type     = terraform
  filename = "iam_sharing_generated.tf"
  command  = ["terraform", "output", "-json"]
}
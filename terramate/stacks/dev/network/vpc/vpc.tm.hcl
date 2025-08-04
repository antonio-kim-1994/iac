generate_hcl "vpc.tf" {
  content {
    module "vpc" {
      source = "../../../../modules/vpc"

      name                 = "${global.name_prefix}-vpc"
      cidr_block           = global.network_settings.vpc_cidr
      enable_dns_support   = global.network_settings.enable_dns_support
      enable_dns_hostnames = global.network_settings.enable_dns_hostnames

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC"
      }
    }
  }
}
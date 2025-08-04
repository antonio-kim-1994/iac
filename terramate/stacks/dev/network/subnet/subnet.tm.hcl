generate_hcl "subnets.tf" {
  content {
    module "attach_subnet_1" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-attach-1"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.attach_subnet_1_cidr
      availability_zone = "${global.aws_region}a"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC attach_subnet_1"
      }
    }

    module "attach_subnet_3" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-attach-3"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.attach_subnet_3_cidr
      availability_zone = "${global.aws_region}c"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC attach_subnet_3"
      }
    }

    module "eks_subnet_1" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-eks-1"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.eks_subnet_1_cidr
      availability_zone = "${global.aws_region}a"

      tags = global.tags

      additional_tags = {
        Description                       = "Dev VPC eks_subnet_1"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }

    module "eks_subnet_3" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-eks-3"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.eks_subnet_3_cidr
      availability_zone = "${global.aws_region}c"

      tags = global.tags
      additional_tags = {
        Description                       = "Dev VPC eks_subnet_3"
        "kubernetes.io/role/internal-elb" = "1"
      }
    }

    module "vpce_subnet_1" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-vpce-1"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.vpce_subnet_1_cidr
      availability_zone = "${global.aws_region}a"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC vpce_subnet_1"
      }
    }

    module "vpce_subnet_3" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-vpce-3"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.vpce_subnet_3_cidr
      availability_zone = "${global.aws_region}c"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC vpce_subnet_3"
      }
    }

    module "rds_subnet_1" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-rds-1"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.rds_subnet_1_cidr
      availability_zone = "${global.aws_region}a"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC rds_subnet_1"
      }
    }

    module "rds_subnet_3" {
      source = "../../../../modules/subnet"

      name              = "${global.name_prefix}-rds-3"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.rds_subnet_3_cidr
      availability_zone = "${global.aws_region}c"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC rds_subnet_3"
      }
    }

    module "lb_subnet_1" {
      source            = "../../../../modules/subnet"
      name              = "${global.name_prefix}-lb-1"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.lb_subnet_1_cidr
      availability_zone = "ap-northeast-2a"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC lb_subnet_1"
      }
    }

    module "lb_subnet_3" {
      source            = "../../../../modules/subnet"
      name              = "${global.name_prefix}-lb-3"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.lb_subnet_3_cidr
      availability_zone = "ap-northeast-2c"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC lb_subnet_3"
      }
    }

    module "ngw_subnet_1" {
      source            = "../../../../modules/subnet"
      name              = "${global.name_prefix}-ngw-1"
      vpc_id            = var.vpc_id
      cidr_block        = global.network_settings.ngw_subnet_1_cidr
      availability_zone = "ap-northeast-2a"

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC ngw_subnet_1"
      }
    }
  }
}
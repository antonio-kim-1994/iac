generate_hcl "route.tf" {
  content {
    # Transit Gateway 데이터 참조
    data "aws_ec2_transit_gateway" "service_tgw" {
      filter {
        name   = "state"
        values = ["available"]
      }

      filter {
        name   = "tag:Name"
        values = ["service_tgw"]
      }
    }

    # Internet Gateway
    # Gateway Resource가 많지 않아 route와 통합
    module "dev_internet_gateway" {
      source = "../../../../modules/internet_gateway"
      name   = "${global.name_prefix}-igw"
      vpc_id = var.vpc_id

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - Internet Gateway"
      }
    }

    module "dev_nat_gateway_1" {
      source    = "../../../../modules/nat_gateway"
      subnet_id = var.ngw_subnet_1_id
      name      = "${global.name_prefix}-ngw-1"
      tags      = global.tags
      additional_tags = {
        Description = "Dev VPC - NAT Gateway"
      }
    }

    // Main Route Table
    module "main_route" {
      source     = "../../../../modules/route"
      name       = "${global.name_prefix}-main-rtb-not-used"
      vpc_id     = var.vpc_id
      subnet_ids = []

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - Default(Not Used) Route Table"
      }
    }

    resource "aws_main_route_table_association" "main_route_association" {
      vpc_id         = var.vpc_id
      route_table_id = module.main_route.main_route_table_id
    }

    module "attach_1_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-attach-1-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.attach_subnet_1_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - route table(ap-northeast-2a) to transit gateway attach"
      }
    }

    module "attach_3_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-attach-3-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.attach_subnet_3_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - route table(ap-northeast-2c) to transit gateway"
      }
    }

    module "eks_1_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-eks-1-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.eks_subnet_1_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - EKS route table(ap-northeast-2a)"
      }
    }

    module "eks_3_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-eks-3-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.eks_subnet_3_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - EKS route table(ap-northeast-2c)"
      }
    }

    module "lb_1_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-lb-1-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.lb_subnet_1_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - ELB route table(ap-northeast-2a)"
      }
    }

    module "lb_3_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-lb-3-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.lb_subnet_3_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - ELB route table(ap-northeast-2c)"
      }
    }

    module "vpce_1_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-vpce-1-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.vpce_subnet_1_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - VPC Endpoint route table(ap-northeast-2a)"
      }
    }

    module "vpce_3_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-vpce-3-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.vpce_subnet_3_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - VPC Endpoint route table(ap-northeast-2c)"
      }
    }

    module "rds_1_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-rds-1-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.rds_subnet_1_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - RDS route table(ap-northeast-2a)"
      }
    }

    module "rds_3_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-rds-3-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpn_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
        {
          destination_cidr_block = global.vpc_cidr
          transit_gateway_id     = data.aws_ec2_transit_gateway.service_tgw.id
        },
      ]
      subnet_ids = [var.rds_subnet_3_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - RDS route table(ap-northeast-2c)"
      }
    }

    module "ngw_1_route" {
      source = "../../../../modules/route"
      name   = "${global.name_prefix}-ngw-1-rtb"
      vpc_id = var.vpc_id
      routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = module.dev_internet_gateway.internet_gateway_id
        }
      ]
      subnet_ids = [var.ngw_subnet_1_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC - NAT G/W route table(ap-northeast-2a)"
      }
    }
  }
}
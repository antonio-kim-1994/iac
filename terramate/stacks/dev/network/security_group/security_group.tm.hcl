generate_hcl "security_group.tf" {
  content {
    module "vpce_sg" {
      source = "../../../../modules/security_group"

      name          = "${global.name_prefix}-vpce-sg"
      description   = "dev vpc vpc endpoint security group"
      vpc_id        = var.vpc_id
      ingress_rules = global.vpce_sg_ingress_rules
      egress_rules  = global.vpce_sg_egress_rules

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC attach_subnet_1"
      }
    }

    module "rds_sg" {
      source = "../../../../modules/security_group"

      name          = "${global.name_prefix}-rds-sg"
      description   = "dev vpc rds security group"
      vpc_id        = var.vpc_id
      ingress_rules = global.rds_sg_ingress_rules
      egress_rules  = global.rds_sg_egress_rules

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC attach_subnet_1"
      }
    }
  }
}
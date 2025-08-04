stack {
  name        = "[Dev] Security Group"
  description = "[Dev] Security Group"
  id          = "9e5f31f1-1540-4f5a-8ac4-1e375cb2b40d"
  tags        = ["dev", "network", "security_group"]

  after = ["/stacks/dev/network/vpc"]
}

input "vpc_id" {
  backend       = "network"
  from_stack_id = "8d5b1d38-c685-43ae-be92-49632e9e694d"
  value         = outputs.vpc_id.value
}

output "vpce_sg_id" {
  description = "Terraform Output: ${global.name_prefix}-vpce-sg의 ID"
  backend     = "network"
  value       = module.vpce_sg.security_group_id
  sensitive   = false
}

globals {
  vpce_sg_description = "vpc endpoint security group"
  vpce_sg_ingress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["${global.network_settings.vpc_cidr}"]
      description = "vpc network inbound traffic"
    }
  ]
  vpce_sg_egress_rules = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description = "vpc outbound traffic"
      from_port   = 0
      protocol    = "-1"
      to_port     = 0
    }
  ]

  rds_sg_description = "rds security group"
  rds_sg_ingress_rules = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["${global.network_settings.eks_subnet_1_cidr}"]
      description = "eks 1 subnet inbound traffic"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["${global.network_settings.eks_subnet_3_cidr}"]
      description = "eks 3 subnet inbound traffic"
    },
  ]

  rds_sg_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "rds outbound traffic"
    }
  ]
}

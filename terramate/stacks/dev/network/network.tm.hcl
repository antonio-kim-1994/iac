globals {
  network_settings = {
    vpc_cidr             = "10.101.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    attach_subnet_1_cidr = "10.101.1.0/26"
    attach_subnet_3_cidr = "10.101.1.128/26"
    eks_subnet_1_cidr    = "10.101.32.0/20"
    eks_subnet_3_cidr    = "10.101.48.0/20"
    vpce_subnet_1_cidr   = "10.101.11.0/24"
    vpce_subnet_3_cidr   = "10.101.13.0/24"

    rds_subnet_1_cidr = "10.101.201.0/24"
    rds_subnet_3_cidr = "10.101.203.0/24"

    lb_subnet_1_cidr = "10.101.101.0/24"
    lb_subnet_3_cidr = "10.101.103.0/24"

    ngw_subnet_1_cidr = "10.101.254.0/26"

    vpn_cidr = "10.10.0.0/23"
  }

  appliance_mode_support = {
    description = "Whether to enable appliance mode support"
    default     = "enable"
  }

  service_tgw_attachment_name = {
    description = "Name of the TGW VPC Attachment"
    default     = "service-tgw-attachment"
  }

  rds_sg_settings = {
    rds_sg_description = "rds security group"
    rds_sg_ingress_rules = [
      {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = [global.network_settings.vpc_cidr]
        description = "vpc network inbound 3306 traffic"
      }
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
}
generate_hcl "vpce.tf" {
  content {
    module "api_ecr_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-api.ecr.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.ecr.api"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC ECR API 호출 엔드포인트"
      }
    }

    module "dkr_ecr_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-dkr.ecr.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.ecr.dkr"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]
      tags = {
        Description = "Dev VPC ECR Docker 레지스트리 엔드포인트"
      }
    }

    module "logs_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-logs.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.logs"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC CloudWatch Logs 엔드포인트"
      }
    }

    module "ec2_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-ec2.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.ec2"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC EC2 엔드포인트"
      }
    }

    module "ec2messages_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-ec2messages.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.ec2messages"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC System Manager의 EC2 message 엔드포인트"
      }
    }

    module "sts_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-sts.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.sts"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC IAM STS 엔드포인트"
      }
    }

    module "eks_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-eks.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.eks"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC EKS 엔드포인트"
      }
    }

    module "eks-auth_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-eks-auth.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.eks-auth"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC EKS 인증 엔드포인트"
      }
    }

    module "ssm_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-ssm.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.ssm"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC System Manager 엔드포인트"
      }
    }

    module "ssmmessages_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-ssmmessages.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.ssmmessages"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC System Manager messages 엔드포인트"
      }
    }

    module "elasticloadbalancing_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-elasticloadbalancing.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.elasticloadbalancing"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC Elastic Loadbalancing 엔드포인트"
      }
    }

    module "secretsmanager_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-secretsmanager.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.secretsmanager"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC Secret Manager 엔드포인트"
      }
    }

    module "autoscaling_vpce" {
      source             = "../../../../modules/vpc_endpoint"
      name               = "${global.name_prefix}-autoscaling.ap-northeast-2.amazonaws.com-vpce"
      vpc_id             = var.vpc_id
      service_name       = "com.amazonaws.ap-northeast-2.autoscaling"
      vpc_endpoint_type  = "Interface"
      subnet_ids         = [var.vpce_subnet_1_id, var.vpce_subnet_3_id]
      security_group_ids = [var.vpce_sg_id]

      tags = global.tags
      additional_tags = {
        Description = "Dev VPC EC2 Autoscaling 엔드포인트"
      }
    }
  }
}
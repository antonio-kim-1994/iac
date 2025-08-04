generate_hcl "eks.tf" {
  content {
    # EKS
    data "aws_caller_identity" "current" {}

    # module "efs_csi_irsa" {
    #   source      = "../../../modules/aws-iam-role-for-service-accounts-eks"
    #   create_role = true
    #
    #   role_name             = "${global.eks_name}-efs-csi"
    #   attach_efs_csi_policy = true
    #
    #   oidc_providers = {
    #     main = {
    #       provider_arn               = module.eks.oidc_provider_arn
    #       namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    #     }
    #   }
    #
    #   tags = global.tags
    #   additional_tags = {
    #     Description = "Dev EKS EFS/CSI IAM role"
    #   }
    #
    #   depends_on = [module.eks.cluster_name]
    # }

    module "vpc_cni_irsa" {
      source      = "../../../modules/aws-iam-role-for-service-accounts-eks"
      create_role = true

      role_name             = "${global.eks_name}-vpc-cni"
      attach_vpc_cni_policy = true
      vpc_cni_enable_ipv4   = true

      oidc_providers = {
        main = {
          provider_arn               = module.eks.oidc_provider_arn
          namespace_service_accounts = ["kube-system:aws-node"]
        }
      }

      tags = global.tags
      additional_tags = {
        Description = "Dev EKS VPC CNI IAM role"
      }

      depends_on = [module.eks.cluster_name]
    }

    locals {
      cluster_name           = "${global.eks_name}"
      node_group_name        = "${local.cluster_name}-node-group"
      iam_role_policy_prefix = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy"
    }

    module "eks" {
      source = "../../../modules/aws-eks-module"

      cluster_timeouts = {
        create = "20m"
        update = "20m"
        delete = "10m"
      }

      cluster_name                    = local.cluster_name
      cluster_version                 = "1.33"
      cluster_endpoint_public_access  = false
      cluster_endpoint_private_access = true

      tags = global.tags
      additional_tags = {
        Description = "Dev EKS Cluster"
      }

      enable_cluster_creator_admin_permissions = true
      access_entries = {
        devops = {
          kubernetes_groups = []
          principal_arn     = "DevOps Role ARN"
          type              = "STANDARD"

          policy_associations = {
            admin = {
              policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
              access_scope = {
                type = "cluster"
              }
            },
            cluster_admin = {
              policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
              access_scope = {
                type = "cluster"
              }
            }

          }
        }
      }

      vpc_id                   = var.vpc_id
      subnet_ids               = [var.eks_subnet_1_id, var.eks_subnet_3_id]
      control_plane_subnet_ids = [var.eks_subnet_1_id, var.eks_subnet_3_id]

      create_cloudwatch_log_group = true

      cluster_addons = {
        coredns    = { most_recent = true }
        kube-proxy = { most_recent = true }
        vpc-cni = {
          before_compute           = true
          most_recent              = true
          service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
          resolve_conflicts        = "PRESERVE"
          #      service_account_role_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        }
        # aws-efs-csi-driver = {
        #   most_recent              = true
        #   service_account_role_arn = module.efs_csi_irsa.iam_role_arn
        # }
      }

      eks_managed_node_group_defaults = {
        ami_type                   = "AL2023_x86_64_STANDARD"
        instance_types             = ["t3.medium"]
        iam_role_attach_cni_policy = true
        vpc_security_group_ids     = []
        iam_role_additional_policies = {
          CloudWatchAgentServerPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
          AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
          AlbIngressControllerPolicy   = "${local.iam_role_policy_prefix}/${var.iam_policy_alb_ingress_controller_name}"
          EKSCommonPolicy              = "${local.iam_role_policy_prefix}/${var.iam_policy_eks_common}"
          # AutosaclingPolicy            = "${local.iam_role_policy_prefix}/${var.iam_policy_autoscaling_name}"
          # EESPolicy                    = "${local.iam_role_policy_prefix}/${var.iam_policy_efs_ecr_secret_manager_name}"
          # ExternalDnsPolicy            = "${local.iam_role_policy_prefix}/${var.iam_policy_external_dns_name}"
        }
      }

      eks_managed_node_groups = {
        "${global.eks_name}-service" = {
          min_size       = 4
          max_size       = 8
          desired_size   = 4
          tags           = global.tags
          instance_types = ["t3a.xlarge"]
          additional_tags = {
            "k8s.io/cluster-autoscaler/enabled" : "true"
            "k8s.io/cluster-autoscaler/${local.cluster_name}" : "true"
            "Datadog" : "enable"
            "alpha.eksctl.io/cluster-name" : local.cluster_name
            "alpha.eksctl.io/nodegroup-name" : local.node_group_name
            "eksctl.cluster.k8s.io/v1alpha1/cluster-name" : local.cluster_name
            "alpha.eksctl.io/nodegroup-type" : "managed"
            "Description" : "Dev EKS Node Group"
          }
          labels = {
            nodeType = "service"
          }
        }

        "${global.eks_name}-addon" = {
          min_size     = 3
          max_size     = 5
          desired_size = 3
          tags         = global.tags
          additional_tags = {
            "k8s.io/cluster-autoscaler/enabled" : "true"
            "k8s.io/cluster-autoscaler/${local.cluster_name}" : "true"
            "Datadog" : "enable"
            "alpha.eksctl.io/cluster-name" : local.cluster_name
            "alpha.eksctl.io/nodegroup-name" : local.node_group_name
            "eksctl.cluster.k8s.io/v1alpha1/cluster-name" : local.cluster_name
            "alpha.eksctl.io/nodegroup-type" : "managed"
            "Description" : "Dev EKS Node Group"
            "service.type" : "addon"
          }
          labels = {
            nodeType = "addon"
          }
        }
      }
    }
  }
}
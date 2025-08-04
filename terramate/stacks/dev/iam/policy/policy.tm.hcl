generate_hcl "policy.tf" {
  content {
    module "iam_policy_autoscaling" {
      source = "../../../../modules/aws-iam-policy"

      name        = "${global.eks_name}-cluster-autoscaler"
      path        = "/"
      description = "Autoscaling policy for cluster ${global.eks_name}"

      policy = data.aws_iam_policy_document.worker_autoscaling.json

      tags = global.tags
      additional_tags = {
        Description = "Dev EKS Autoscaling policy"
      }
    }

    data "aws_iam_policy_document" "worker_autoscaling" {
      statement {
        sid    = "eksWorkerAutoscalingAll"
        effect = "Allow"

        actions = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup",
        ]

        resources = ["*"]
      }

      statement {
        sid    = "eksWorkerAutoscalingOwn"
        effect = "Allow"

        actions = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
        ]

        resources = ["*"]

        condition {
          test     = "StringEquals"
          variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${global.eks_name}"
          values   = ["owned"]
        }

        condition {
          test     = "StringEquals"
          variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
          values   = ["true"]
        }
      }
    }

    module "iam_policy_alb_ingress_controller" {
      source = "../../../../modules/aws-iam-policy"

      name        = "${global.eks_name}-alb-ingress-controller"
      path        = "/"
      description = "alb ingress controller policy for cluster ${global.eks_name}"

      policy = data.aws_iam_policy_document.alb_ingress_controller.json

      tags = global.tags
      additional_tags = {
        Description = "Dev EKS Application LoadBalancer policy"
      }
    }

    data "aws_iam_policy_document" "alb_ingress_controller" {
      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]
        actions   = ["iam:CreateServiceLinkedRole"]

        condition {
          test     = "StringEquals"
          variable = "iam:AWSServiceName"
          values   = ["elasticloadbalancing.amazonaws.com"]
        }
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVpcs",
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeTags",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeCoipPools",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeListenerCertificates",
          "elasticloadbalancing:DescribeListenerAttributes",
          "elasticloadbalancing:DescribeSSLPolicies",
          "elasticloadbalancing:DescribeRules",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DescribeTags",
          "elasticloadbalancing:DescribeListenerAttributes"
        ]
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "cognito-idp:DescribeUserPoolClient",
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "iam:ListServerCertificates",
          "iam:GetServerCertificate",
          "waf-regional:GetWebACL",
          "waf-regional:GetWebACLForResource",
          "waf-regional:AssociateWebACL",
          "waf-regional:DisassociateWebACL",
          "wafv2:GetWebACL",
          "wafv2:GetWebACLForResource",
          "wafv2:AssociateWebACL",
          "wafv2:DisassociateWebACL",
          "shield:GetSubscriptionState",
          "shield:DescribeProtection",
          "shield:CreateProtection",
          "shield:DeleteProtection",
        ]
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
        ]
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]
        actions   = ["ec2:CreateSecurityGroup"]
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["arn:aws:ec2:*:*:security-group/*"]
        actions   = ["ec2:CreateTags"]

        condition {
          test     = "StringEquals"
          variable = "ec2:CreateAction"
          values   = ["CreateSecurityGroup"]
        }

        condition {
          test     = "Null"
          variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
          values   = ["false"]
        }
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["arn:aws:ec2:*:*:security-group/*"]

        actions = [
          "ec2:CreateTags",
          "ec2:DeleteTags",
        ]

        condition {
          test     = "Null"
          variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
          values   = ["true"]
        }

        condition {
          test     = "Null"
          variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
          values   = ["false"]
        }
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:DeleteSecurityGroup",
        ]

        condition {
          test     = "Null"
          variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
          values   = ["false"]
        }
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateTargetGroup",
        ]

        condition {
          test     = "Null"
          variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
          values   = ["false"]
        }
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:DeleteRule",
        ]
      }

      statement {
        sid    = ""
        effect = "Allow"

        resources = [
          "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
        ]

        actions = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
        ]

        condition {
          test     = "Null"
          variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
          values   = ["true"]
        }

        condition {
          test     = "Null"
          variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
          values   = ["false"]
        }
      }

      statement {
        sid    = ""
        effect = "Allow"

        resources = [
          "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
          "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*",
        ]

        actions = [
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
        ]
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:SetIpAddressType",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:DeleteTargetGroup",
        ]

        condition {
          test     = "Null"
          variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
          values   = ["false"]
        }
      }

      statement {
        sid    = ""
        effect = "Allow"

        resources = [
          "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
          "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
        ]

        actions = ["elasticloadbalancing:AddTags"]

        condition {
          test     = "StringEquals"
          variable = "elasticloadbalancing:CreateAction"

          values = [
            "CreateTargetGroup",
            "CreateLoadBalancer",
          ]
        }

        condition {
          test     = "Null"
          variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
          values   = ["false"]
        }
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]

        actions = [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
        ]
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]

        actions = [
          "elasticloadbalancing:SetWebAcl",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:AddListenerCertificates",
          "elasticloadbalancing:RemoveListenerCertificates",
          "elasticloadbalancing:ModifyRule",
        ]
      }
    }

    module "iam_policy_efs_ecr_secret_manager" {
      source = "../../../../modules/aws-iam-policy"

      name        = "${global.eks_name}-efs-ecr-secretmanager"
      path        = "/"
      description = "efs policy for cluster ${global.eks_name}"

      policy = data.aws_iam_policy_document.efs_ecr_secret_manager.json

      tags = global.tags
      additional_tags = {
        Description = "Dev EKS EFS/ECR/Secret Manager policy"
      }
    }

    data "aws_iam_policy_document" "efs_ecr_secret_manager" {
      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]
        actions = [
          "secretsmanager:GetSecretValue",
          "elasticfilesystem:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
      }
    }

    module "iam_policy_external_dns" {
      source = "../../../../modules/aws-iam-policy"

      name        = "${global.eks_name}-external-dns"
      path        = "/"
      description = "external dns change set policy for cluster ${global.eks_name}"

      policy = data.aws_iam_policy_document.external_dns.json

      tags = global.tags
      additional_tags = {
        Description = "Dev EKS External DNS policy"
      }
    }

    data "aws_iam_policy_document" "external_dns" {
      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]
        actions = [
          "route53:ChangeResourceRecordSets",
          "route53:GetChange",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]
      }
    }

    module "iam_policy_eks_common" {
      source = "../../../../modules/aws-iam-policy"

      name        = "${global.eks_name}-common-access-policy"
      path        = "/"
      description = "Common access policy for cluster ${global.eks_name}"

      policy = data.aws_iam_policy_document.common_policy.json

      tags = global.tags
      additional_tags = {
        Description = "${global.eks_name} cluster access policy"
      }
    }

    data "aws_iam_policy_document" "common_policy" {
      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]
        actions = [
          "route53:ChangeResourceRecordSets",
          "route53:GetChange",
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]
      }

      statement {
        sid       = ""
        effect    = "Allow"
        resources = ["*"]
        actions = [
          "secretsmanager:GetSecretValue",
          "elasticfilesystem:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
      }

      statement {
        sid    = "eksWorkerAutoscalingAll"
        effect = "Allow"

        actions = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup",
        ]

        resources = ["*"]
      }

      statement {
        sid    = "eksWorkerAutoscalingOwn"
        effect = "Allow"

        actions = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:UpdateAutoScalingGroup",
        ]

        resources = ["*"]

        condition {
          test     = "StringEquals"
          variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${global.eks_name}"
          values   = ["owned"]
        }

        condition {
          test     = "StringEquals"
          variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
          values   = ["true"]
        }
      }
    }
  }
}
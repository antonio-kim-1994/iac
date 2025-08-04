generate_hcl "service.tf" {
  content {
    data "aws_eks_cluster" "eks_info" {
      name = global.eks_name # 조회할 EKS 클러스터 이름
    }

    provider "kubernetes" {
      host                     = data.aws_eks_cluster.eks_info.endpoint
      cluster_ca_certificate   = base64decode(data.aws_eks_cluster.eks_info.certificate_authority[0].data)
      config_context           = ""
      config_context_auth_info = ""

      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        args        = ["eks", "get-token", "--cluster-name", global.eks_name]
        command     = "aws"
      }
    }

    provider "helm" {
      kubernetes {
        host                     = data.aws_eks_cluster.eks_info.endpoint
        cluster_ca_certificate   = base64decode(data.aws_eks_cluster.eks_info.certificate_authority[0].data)
        config_context           = data.aws_eks_cluster.eks_info.arn
        config_context_auth_info = data.aws_eks_cluster.eks_info.arn

        exec {
          api_version = "client.authentication.k8s.io/v1beta1"
          args        = ["eks", "get-token", "--cluster-name", global.eks_name]
          command     = "aws"
        }
      }
    }

    resource "helm_release" "service" {
      name      = global.service_name
      chart     = "../../../../../modules/helm/argocd-application"
      namespace = "argocd"

      dependency_update = true
      cleanup_on_fail   = true
      max_history       = 1

      values = [
        "${file("./argo_application.yaml")}"
      ]
    }
  }
}

generate_file "argo_application.yaml" {
  content = tm_yamlencode({
    argoApplication = {
      ecrUrl         = global.ecr_url
      chart          = global.chart
      manifestGitUrl = global.manifest_git_url
      applications = [
        {
          name      = global.service_name
          namespace = global.namespace
        }
      ]
    }
  })
}
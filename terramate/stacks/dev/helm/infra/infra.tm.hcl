generate_hcl "infra.tf" {
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

    resource "kubernetes_namespace" "namespaces" {
      for_each = toset(global.namespace_list) # 리스트를 Set으로 변환해 for_each 사용
      metadata {
        name = each.value # 현재 반복 중인 네임스페이스 이름
        labels = {
          "istio-injection" = "enabled" # Istio injection label 추가
        }
      }
    }

    resource "helm_release" "cert_manager" {
      name             = "cert-manager"
      chart            = "cert-manager"
      repository       = "https://charts.jetstack.io"
      create_namespace = true
      namespace        = "cert-manager"
      version          = "v1.16.1"

      cleanup_on_fail = true
      values = [
        "${file("./helm/cert-manager-values.yaml")}"
      ]

      depends_on = [kubernetes_namespace.namespaces]
    }

    resource "helm_release" "aws-loadbalancer-controller" {
      name              = "aws-loadbalancer-controller"
      chart             = "../../../../modules/helm/aws-loadbalancer-controller"
      namespace         = "kube-system"
      create_namespace  = false
      dependency_update = true
      cleanup_on_fail   = true

      values = [
        "${file("./helm/aws-loadbalancer-controller.yaml")}"
      ]

      depends_on = [helm_release.cert_manager]
    }

    resource "helm_release" "cluster_autoscaler" {
      name       = "cluster-autoscaler"
      chart      = "cluster-autoscaler"
      repository = "https://kubernetes.github.io/autoscaler"
      namespace  = "kube-system"

      cleanup_on_fail = true
      values = [
        "${file("./helm/cluster-autoscaler-values.yaml")}"
      ]
    }

    resource "helm_release" "external-secrets" {
      name              = "external-secrets"
      chart             = "../../../../modules/helm/external-secrets"
      namespace         = "external-secrets"
      create_namespace  = true
      dependency_update = true
      cleanup_on_fail   = true

      values = [
        "${file("./helm/external-secrets-values.yaml")}"
      ]

      depends_on = [kubernetes_namespace.namespaces]
    }

    resource "helm_release" "istio_base" {
      name         = "istio-base"
      repository   = "https://istio-release.storage.googleapis.com/charts"
      chart        = "base"
      namespace    = "istio-system"
      force_update = true

      create_namespace = true
      cleanup_on_fail  = true

      values = [
        "${file("./helm/istio-base-values.yaml")}"
      ]

      depends_on = [helm_release.external-secrets]
    }

    resource "helm_release" "istiod" {
      name             = "istiod"
      chart            = "istiod"
      repository       = "https://istio-release.storage.googleapis.com/charts"
      namespace        = "istio-system"
      create_namespace = true
      force_update     = true

      cleanup_on_fail = true
      values = [
        "${file("./helm/istiod-values.yaml")}"
      ]

      depends_on = [helm_release.istio_base]
    }

    resource "helm_release" "istio-gateway" {
      name              = "istio-ingressgateway"
      chart             = "../../../../modules/helm/istio-gateway"
      namespace         = "istio-system"
      create_namespace  = true
      dependency_update = true
      force_update      = true
      reuse_values      = true

      cleanup_on_fail = true
      values = [
        "${file("./helm/ingress-values.yaml")}"
      ]
      depends_on = [helm_release.istiod]
    }

    resource "helm_release" "datadog" {
      name      = "datadog"
      chart     = "../../../../modules/helm/datadog"
      namespace = "datadog"

      force_update      = true
      dependency_update = true
      cleanup_on_fail   = true
      values = [
        "${file("./helm/datadog-values.yaml")}"
      ]

      depends_on = [helm_release.external-secrets]

      timeout = 1200
    }

    resource "helm_release" "argocd" {
      name      = "argocd"
      chart     = "../../../../modules/helm/argocd"
      namespace = "argocd"

      dependency_update = true
      cleanup_on_fail   = true
      max_history       = 1

      values = [
        "${file("./helm/argo-cd-values.yaml")}"
      ]
    }
  }
}
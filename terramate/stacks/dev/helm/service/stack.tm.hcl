stack {
  name        = "[Dev] Service with Helm"
  description = "[Dev] Service with Helm"
  id          = "59024c08-f607-4342-b442-dada74cd6716"

  tags = ["dev", "helm", "service"]
}

globals {
  ecr_url          = "430118820777.dkr.ecr.ap-northeast-2.amazonaws.com"
  manifest_git_url = "https://github.com/sample-org/eks-helm-dev.git"
  chart            = "helm/service-common"
}
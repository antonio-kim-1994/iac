stack {
  name        = "[Dev] EKS"
  description = "[Dev] EKS"
  id          = "aff3837d-aafe-47ca-a6bd-edcf65698239"
  tags        = ["dev", "eks"]

  after = ["/stacks/dev/iam/policy"]
}

input "vpc_id" {
  backend       = "network"
  from_stack_id = "8d5b1d38-c685-43ae-be92-49632e9e694d"
  value         = outputs.vpc_id.value
}

input "eks_subnet_1_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.eks_subnet_1_id.value
}

input "eks_subnet_3_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.eks_subnet_3_id.value
}

input "iam_policy_autoscaling_name" {
  backend       = "iam"
  from_stack_id = "dev-iam-policy"
  value         = outputs.iam_policy_autoscaling_name.value
}

input "iam_policy_alb_ingress_controller_name" {
  backend       = "iam"
  from_stack_id = "dev-iam-policy"
  value         = outputs.iam_policy_alb_ingress_controller_name.value
}

input "iam_policy_efs_ecr_secret_manager_name" {
  backend       = "iam"
  from_stack_id = "dev-iam-policy"
  value         = outputs.iam_policy_efs_ecr_secret_manager_name.value
}

input "iam_policy_external_dns_name" {
  backend       = "iam"
  from_stack_id = "dev-iam-policy"
  value         = outputs.iam_policy_external_dns_name.value
}

input "iam_policy_eks_common" {
  backend       = "iam"
  from_stack_id = "dev-iam-policy"
  value         = outputs.iam_policy_eks_common.value
}
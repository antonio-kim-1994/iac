stack {
  name        = "[Dev] IAM Policy"
  description = "[Dev] IAM Policy"
  id          = "service-iam-policy"
  tags        = ["dev", "iam", "policy"]

  after = ["/stacks/dev/network/vpce"]
}

output "iam_policy_autoscaling_name" {
  description = "Terraform Output: iam_policy_autoscaling의 name"
  backend     = "iam"
  value       = module.iam_policy_autoscaling.name
  sensitive   = false
}

output "iam_policy_alb_ingress_controller_name" {
  description = "Terraform Output: iam_policy_alb_ingress_controller의 name"
  backend     = "iam"
  value       = module.iam_policy_alb_ingress_controller.name
  sensitive   = false
}

output "iam_policy_efs_ecr_secret_manager_name" {
  description = "Terraform Output: iam_policy_efs_ecr_secret_manager의 name"
  backend     = "iam"
  value       = module.iam_policy_efs_ecr_secret_manager.name
  sensitive   = false
}

output "iam_policy_external_dns_name" {
  description = "Terraform Output: iam_policy_external_dns의 name"
  backend     = "iam"
  value       = module.iam_policy_external_dns.name
  sensitive   = false
}

output "iam_policy_eks_common" {
  description = "Terraform Output: iam_policy_eks_common의 name"
  backend     = "iam"
  value       = module.iam_policy_eks_common.name
  sensitive   = false
}
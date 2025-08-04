stack {
  name        = "[Dev] Subnet"
  description = "[Dev] Subnet"
  id          = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  tags        = ["dev", "network", "subnet"]

  after = ["/stacks/dev/network/vpc"]
}

input "vpc_id" {
  backend       = "network"
  from_stack_id = "8d5b1d38-c685-43ae-be92-49632e9e694d"
  value         = outputs.vpc_id.value
}

output "ngw_subnet_1_id" {
  description = "Terraform Output: ${global.name_prefix}-ngw-1의 ID"
  backend     = "network"
  value       = module.ngw_subnet_1.subnet_id
  sensitive   = false
}

output "attach_subnet_1_id" {
  description = "Terraform Output: ${global.name_prefix}-attach-1의 subnet ID"
  backend     = "network"
  value       = module.attach_subnet_1.subnet_id
  sensitive   = false
}

output "attach_subnet_3_id" {
  description = "Terraform Output: ${global.name_prefix}-attach-3의 subnet ID"
  backend     = "network"
  value       = module.attach_subnet_3.subnet_id
  sensitive   = false
}

output "eks_subnet_1_id" {
  description = "Terraform Output: ${global.name_prefix}-eks-1의 subnet ID"
  backend     = "network"
  value       = module.eks_subnet_1.subnet_id
  sensitive   = false
}

output "eks_subnet_3_id" {
  description = "Terraform Output: ${global.name_prefix}-eks-3의 subnet ID"
  backend     = "network"
  value       = module.eks_subnet_3.subnet_id
  sensitive   = false
}

output "lb_subnet_1_id" {
  description = "Terraform Output: ${global.name_prefix}-lb-1의 subnet ID"
  backend     = "network"
  value       = module.lb_subnet_1.subnet_id
  sensitive   = false
}

output "lb_subnet_3_id" {
  description = "Terraform Output: ${global.name_prefix}-lb-3의 subnet ID"
  backend     = "network"
  value       = module.lb_subnet_3.subnet_id
  sensitive   = false
}

output "rds_subnet_1_id" {
  description = "Terraform Output: ${global.name_prefix}-rds-1의 subnet ID"
  backend     = "network"
  value       = module.rds_subnet_1.subnet_id
  sensitive   = false
}

output "rds_subnet_3_id" {
  description = "Terraform Output: ${global.name_prefix}-rds-3의 subnet ID"
  backend     = "network"
  value       = module.rds_subnet_3.subnet_id
  sensitive   = false
}

output "vpce_subnet_1_id" {
  description = "Terraform Output: ${global.name_prefix}-vpce-1의 subnet ID"
  backend     = "network"
  value       = module.vpce_subnet_1.subnet_id
  sensitive   = false
}

output "vpce_subnet_3_id" {
  description = "Terraform Output: ${global.name_prefix}-vpce-3의 subnet ID"
  backend     = "network"
  value       = module.vpce_subnet_3.subnet_id
  sensitive   = false
}
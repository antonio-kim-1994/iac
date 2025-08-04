stack {
  name        = "[Dev] VPC"
  description = "[Dev] VPC"
  id          = "8d5b1d38-c685-43ae-be92-49632e9e694d"
  tags        = ["dev", "network", "vpc"]
}

output "vpc_id" {
  description = "Terraform Output: ${global.name_prefix}-vpc의 ID"
  backend     = "network"
  value       = module.vpc.vpc_id
  sensitive   = false
}
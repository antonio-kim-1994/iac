stack {
  name        = "[Dev] Route"
  description = "[Dev] Route"
  id          = "eab10930-47bc-4494-9c7d-0ea7b58630c9"
  tags        = ["dev", "network", "route"]

  after = ["/stacks/dev/network/subnet"]
}

input "vpc_id" {
  backend       = "network"
  from_stack_id = "8d5b1d38-c685-43ae-be92-49632e9e694d"
  value         = outputs.vpc_id.value
}

input "ngw_subnet_1_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.ngw_subnet_1_id.value
}

input "attach_subnet_1_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.attach_subnet_1_id.value
}

input "attach_subnet_3_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.attach_subnet_3_id.value
}

input "lb_subnet_1_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.lb_subnet_1_id.value
}

input "lb_subnet_3_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.lb_subnet_3_id.value
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

input "rds_subnet_1_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.rds_subnet_1_id.value
}

input "rds_subnet_3_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.rds_subnet_3_id.value
}

input "vpce_subnet_1_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.vpce_subnet_1_id.value
}

input "vpce_subnet_3_id" {
  backend       = "network"
  from_stack_id = "cf823984-0c94-44ae-bdd2-e98ea7a5dd04"
  value         = outputs.vpce_subnet_3_id.value
}
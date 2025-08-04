stack {
  name        = "[Dev] VPC Endpoint"
  description = "[Dev] VPC Endpoint"
  id          = "476cc6de-1834-467b-b02c-88badef0bf15"
  tags        = ["dev", "network", "vpce"]

  after = ["/stacks/dev/network/security_group"]
}

input "vpc_id" {
  backend       = "network"
  from_stack_id = "8d5b1d38-c685-43ae-be92-49632e9e694d"
  value         = outputs.vpc_id.value
}

input "vpce_sg_id" {
  backend       = "network"
  from_stack_id = "9e5f31f1-1540-4f5a-8ac4-1e375cb2b40d"
  value         = outputs.vpce_sg_id.value
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

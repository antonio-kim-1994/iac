stack {
  name        = "[Dev] Service Front"
  description = "[Dev] Service Front"
  id          = "b16d7f3e-b10a-498c-a18c-8a9cf4ad0ae9"
  tags        = ["dev", "helm", "service", "service-front"]
}

globals {
  helm_hook_weight = "11"
  service_name     = "service-front"
  namespace        = "service"
}
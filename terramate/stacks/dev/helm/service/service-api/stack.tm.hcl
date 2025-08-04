stack {
  name        = "[Dev] Service API"
  description = "[Dev] Service API"
  id          = "463cfe9b-16e0-4bef-b3ac-77a531f0a3e0"
  tags        = ["dev", "helm", "service", "service-api"]

}

globals {
  helm_hook_weight = "11"
  service_name     = "service-api"
  namespace        = "service"
}
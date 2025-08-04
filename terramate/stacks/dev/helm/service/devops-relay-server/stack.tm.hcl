stack {
  name        = "[Dev] DevOps Relay Server"
  description = "[Dev] DevOps Relay Server"
  id          = "8b1ca696-5331-40bc-9901-1dedcfedab30"

  tags = ["dev", "helm", "service", "devops-relay"]
}

globals {
  service_name = "devops-relay-server"
  namespace    = "devops"
  create_dns   = false
}

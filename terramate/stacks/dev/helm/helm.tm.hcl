globals {
  namespace_list = ["argocd", "datadog", "service", "devops"]
  service_list = [
    {
      "createEcr" : true,
      "dnsName" : "",
      "gitUrl" : "",
      "createDns" : true,
      "name" : "service-api",
      "namespace" : "service"
    },
    {
      "createEcr" : true,
      "dnsName" : "",
      "gitUrl" : "",
      "createDns" : true,
      "name" : "service-front",
      "namespace" : "service"
    },
    {
      "createEcr" : false,
      "dnsName" : "",
      "gitUrl" : "",
      "createDns" : true,
      "name" : "devops-relay-server",
      "namespace" : "devops"
    }
  ]
}
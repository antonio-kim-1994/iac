# Provider
provider "ncloud" {
  access_key  = var.access_key
  region      = "FKR"
  secret_key  = var.secret_key
  site        = var.site
  support_vpc = true
}

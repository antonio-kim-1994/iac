# VPC Output
output "vpc_id" {
  value = ncloud_vpc.smaple_vpc.id
}

output "kubernetes_subnet_id" {
  value = ncloud_subnet.kubernetes_subnet.id
}

output "kubernetes_subnet_lb_id" {
  value = ncloud_subnet.kubernetes_lb_subnet.id
}
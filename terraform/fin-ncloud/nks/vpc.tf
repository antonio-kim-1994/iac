# 기존에 생성된 VPC 호출
# import {
#   to = ncloud_vpc.imported_vpc
#   id = var.imported_vpc // VPC ID
# }

# Resource : VPC
resource "ncloud_vpc" "smaple_vpc" {
  ipv4_cidr_block = "172.16.0.0/16"
}

# Resource : ACL(Access Control List)
resource "ncloud_network_acl" "kubernetes_acl" {
  vpc_no      = ncloud_vpc.smaple_vpc.id
  name        = "sample-acl"
  description = "Kubernetes Cluster 전용"
}

# Resource : Subnet(Private)
resource "ncloud_subnet" "kubernetes_subnet" {
  network_acl_no = ncloud_network_acl.kubernetes_acl.id
  subnet         = cidrsubnet(ncloud_vpc.smaple_vpc.ipv4_cidr_block , 8 , 0)
  subnet_type    = "PRIVATE" // PUBLIC(Public) | PRIVATE(Private)
  vpc_no         = ncloud_vpc.smaple_vpc.id
  zone           = "FKR-1"
  name           = "SUBNET_NAME"
  usage_type     = "GEN" // GEN(General) | LOADB(For load balancer)
}

# Resource : Subnet(Private LB)
resource "ncloud_subnet" "kubernetes_lb_subnet" {
  network_acl_no = ncloud_network_acl.kubernetes_acl.id
  subnet         = cidrsubnet(ncloud_vpc.smaple_vpc.ipv4_cidr_block , 8 , 1)
  subnet_type    = "PRIVATE"
  vpc_no         = ncloud_vpc.smaple_vpc.id
  zone           = "FKR-1"
  name           = "SUBNET_NAME"
  usage_type     = "LOADB"
}

# Route Table
resource "ncloud_route_table" "kubernetes_route_table" {
  supported_subnet_type = "PRIVATE" // PUBLIC(Public) | PRIVATE(Private)
  vpc_no                = ncloud_vpc.smaple_vpc.id
  name                  = "kubernetes-route"
  description           = "Kubernetes Cluster Subnet 전용 Route Table"
}

# Route Table Association
resource "ncloud_route_table_association" "kubernetes_route_table_subnet" {
  route_table_no = ncloud_route_table.kubernetes_route_table.id
  subnet_no      = ncloud_subnet.kubernetes_subnet.id
}

resource "ncloud_route_table_association" "kubernetes_lb_route_table_subnet" {
  route_table_no = ncloud_route_table.kubernetes_route_table.id
  subnet_no      = ncloud_subnet.kubernetes_lb_subnet.id
}

# 기존에 생성된 NATGW 호출
#import {
#  to = ncloud_nat_gateway.stage_nat_gateway
#  id = "NAT_ID"
#}

resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no = ncloud_vpc.smaple_vpc.id
  zone   = "FKR-1"
  name   = "sample-natgateway"
}

# Route Rule Configuration
resource "ncloud_route" "kubernetes_route_natgw" {
  destination_cidr_block = "0.0.0.0/0"
  target_type            = "NATGW" // NATGW (NAT Gateway) | VPCPEERING (VPC Peering) | VGW (Virtual Private Gateway).
  route_table_no         = ncloud_route_table.kubernetes_route_table.id
  target_name            = ncloud_nat_gateway.nat_gateway.name
  target_no              = ncloud_nat_gateway.nat_gateway.id
}
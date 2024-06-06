# 기존에 생성된 VPC 호출
import {
  to = ncloud_vpc.imported_vpc
  id = var.imported_vpc_id // VPC ID
}

import {
  to = ncloud_nat_gateway.nat_gateway
  id = var.natgw_id
}

import {
  to = ncloud_subnet.kube_subnet
  id = var.nks_subnet_id
}

import {
  to = ncloud_subnet.kube_lb_subnet
  id = var.nks_lb_subnet_id
}

import {
  to = ncloud_route_table.kube_route_table
  id = var.nks_route_table
}

import {
  to = ncloud_network_acl.kube_acl
  id = var.nks_acl_id
}

# Resource : VPC
# terraform import ncloud_vpc.imported_live_vpc <value> 명령어 실행 필요
resource "ncloud_vpc" "imported_vpc" {
  ipv4_cidr_block = var.vpc_ipv4_block

  lifecycle {
    prevent_destroy = true
  }
}

# Resource : ACL(Access Control List)
resource "ncloud_network_acl" "kube_acl" {
  vpc_no      = ncloud_vpc.imported_vpc.id
  name        = "stage-kube-acl"
  description = "Stage Kubernetes Cluster 상품 전용"
}

# Resource : Subnet(Private)
resource "ncloud_subnet" "kube_subnet" {
  network_acl_no = ncloud_network_acl.kube_acl.id
  subnet         = var.kube_subnet
  subnet_type    = "PRIVATE" // PUBLIC(Public) | PRIVATE(Private)
  vpc_no         = ncloud_vpc.imported_vpc.id
  zone           = "FKR-1"
  name           = "stage-kube-subnet"
  usage_type     = "GEN" // GEN(General) | LOADB(For load balancer)
}

# Resource : Subnet(Private LB)
resource "ncloud_subnet" "kube_lb_subnet" {
  network_acl_no = ncloud_network_acl.kube_acl.id
  subnet         = var.kube_lb_subnet
  subnet_type    = "PRIVATE"
  vpc_no         = ncloud_vpc.imported_vpc.id
  zone           = "FKR-1"
  name           = "stage-kube-lb-subnet"
  usage_type     = "LOADB"
}

# Route Table
resource "ncloud_route_table" "kube_route_table" {
  supported_subnet_type = "PRIVATE" // PUBLIC(Public) | PRIVATE(Private)
  vpc_no                = ncloud_vpc.imported_vpc.id
  name                  = "stage-kube-route"
  description           = "Stage Kubernetes Cluster Subnet 전용 Route Table"
}

# Route Table Association
# resource "ncloud_route_table_association" "kube_route_table_subnet" {
#   route_table_no = ncloud_route_table.kube_route_table.id
#   subnet_no      = ncloud_subnet.kube_subnet.id
# }

# resource "ncloud_route_table_association" "kube_lb_route_table_subnet" {
#   route_table_no = ncloud_route_table.kube_route_table.id
#   subnet_no      = ncloud_subnet.kube_lb_subnet.id
# }


# 기존에 생성된 NATGW 호출
# terraform import ncloud_nat_gateway.nat_gateway <value> 명령어 실행 필요
resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no = ncloud_vpc.imported_vpc.id
  zone   = "FKR-1"
  name   = "test-natgateway"

  lifecycle {
    prevent_destroy = true
  }
}

# Route Rule Configuration
# resource "ncloud_route" "kube_route_natgw" {
#   destination_cidr_block = "0.0.0.0/0"
#   target_type            = "NATGW" // NATGW (NAT Gateway) | VPCPEERING (VPC Peering) | VGW (Virtual Private Gateway).
#   route_table_no         = ncloud_route_table.kube_route_table.id
#   target_name            = ncloud_nat_gateway.nat_gateway.name
#   target_no              = ncloud_nat_gateway.nat_gateway.id
# }

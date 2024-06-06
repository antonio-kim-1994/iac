data "ncloud_nks_versions" "version" {
  filter {
    name   = "value"
    values = ["1.27"]
    regex  = true
  }
}

# import {
#   to = ncloud_login_key.login_key
#   id = "live-key"
# }

resource "ncloud_login_key" "login_key" {
  key_name = "live-key"

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "ncloud_nks_cluster" "cluster" {
  cluster_type         = var.nks_cluster_type
  k8s_version          = data.ncloud_nks_versions.version.versions.0.value
  lb_private_subnet_no = ncloud_subnet.stage_kube_lb_subnet.id
  login_key_name       = ncloud_login_key.login_key.key_name
  name                 = "stage-kube-cluster"
  subnet_no_list       = [ncloud_subnet.stage_kube_subnet.id]
  vpc_no               = ncloud_vpc.imported_live_vpc.id
  zone                 = var.zone
  kube_network_plugin  = "cilium"
  log {
    audit = true
  }
}

data "ncloud_nks_server_images" "server_image" {
  hypervisor_code = "XEN"
  filter {
    name   = "label"
    values = ["ubuntu-20.04"]
    regex  = true
  }
}

data "ncloud_nks_server_products" "devops_servers" {
  software_code = data.ncloud_nks_server_images.server_image.images[0].value
  zone          = var.zone

  filter {
    name   = "product_type"
    values = ["STAND"]
  }

  filter {
    name   = "cpu_count"
    values = ["2"]
  }

  filter {
    name   = "memory_size"
    values = ["8GB"]
  }
}

data "ncloud_nks_server_products" "service_servers" {
  software_code = data.ncloud_nks_server_images.server_image.images[0].value
  zone          = var.zone

  filter {
    name   = "product_type"
    values = ["STAND"]
  }

  filter {
    name   = "cpu_count"
    values = ["4"]
  }

  filter {
    name   = "memory_size"
    values = ["8GB"]
  }
}

data "ncloud_nks_server_products" "db_servers" {
  software_code = data.ncloud_nks_server_images.server_image.images[0].value
  zone          = var.zone

  filter {
    name   = "product_type"
    values = ["STAND"]
  }

  filter {
    name   = "cpu_count"
    values = ["4"]
  }

  filter {
    name   = "memory_size"
    values = ["8GB"]
  }
}

resource "ncloud_nks_node_pool" "devops_nodepool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_count     = 2
  node_pool_name = "devops-nodes"
  product_code   = data.ncloud_nks_server_products.devops_servers.products[0].value
  software_code  = data.ncloud_nks_server_images.server_image.images[0].value
  subnet_no_list = [ncloud_subnet.stage_kube_subnet.id]
  autoscale {
    enabled = true
    max     = 3
    min     = 2
  }
}

resource "ncloud_nks_node_pool" "service_nodepool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_count     = 2
  node_pool_name = "service-nodes"
  product_code   = data.ncloud_nks_server_products.service_servers.products[0].value
  software_code  = data.ncloud_nks_server_images.server_image.images[0].value
  subnet_no_list = [ncloud_subnet.stage_kube_subnet.id]
  autoscale {
    enabled = true
    max     = 4
    min     = 2
  }
}

resource "ncloud_nks_node_pool" "database_nodepool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_count     = 2
  node_pool_name = "database-nodepool"
  product_code   = data.ncloud_nks_server_products.db_servers.products[0].value
  software_code  = data.ncloud_nks_server_images.server_image.images[0].value
  subnet_no_list = [ncloud_subnet.stage_kube_subnet.id]
  autoscale {
    enabled = true
    max     = 4
    min     = 2
  }
}

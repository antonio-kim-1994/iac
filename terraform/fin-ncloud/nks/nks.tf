data "ncloud_nks_versions" "version" {
  filter {
    name   = "value"
    values = ["1.27"]
    regex = true
  }
}

resource "ncloud_login_key" "loginkey" {
  key_name = "sample-login-key"
}

resource "ncloud_nks_cluster" "cluster" {
  # Cluster Type(XEN?RHV)
  # 10 ea : SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002
  # 50 ea : SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002
  cluster_type         = "SVR.VNKS.STAND.C004.M016.NET.SSD.B050.G002"
  k8s_version = data.ncloud_nks_versions.version.versions.0.value
  lb_private_subnet_no = ncloud_subnet.kubernetes_lb_subnet.id
  login_key_name       = ncloud_login_key.loginkey.key_name
  name                 = "kubernetes-cluster"
  subnet_no_list       = [ ncloud_subnet.kubernetes_subnet.id ]
  vpc_no               = ncloud_vpc.smaple_vpc.id
  zone                 = var.zone
  kube_network_plugin = "cilium"
  log {
    audit = true
  }
}

data "ncloud_nks_server_images" "server_image" {
  filter {
    name   = "label"
    values = ["ubuntu-20.04"]
    regex = true
  }
  hypervisor_code = "XEN"
}

data "ncloud_nks_server_products" "devops_servers" {
  software_code = data.ncloud_nks_server_images.server_image.images[0].value
  zone = var.zone

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
  zone = var.zone

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
  node_count     = 1
  node_pool_name = "devops-nodes-1"
  product_code   = data.ncloud_nks_server_products.devops_servers.products[0].value
  software_code = data.ncloud_nks_server_images.server_image.images[0].value
  subnet_no_list = [ncloud_subnet.kubernetes_subnet.id]
  autoscale {
    enabled = true
    max     = 3
    min     = 1
  }
}

resource "ncloud_nks_node_pool" "service_nodepool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_count     = 2
  node_pool_name = "service-nodes-1"
  product_code   = data.ncloud_nks_server_products.service_servers.products[0].value
  software_code = data.ncloud_nks_server_images.server_image.images[0].value
  subnet_no_list = [ncloud_subnet.kubernetes_subnet.id]
  autoscale {
    enabled = true
    max     = 5
    min     = 2
  }
}

resource "ncloud_nks_node_pool" "database_nodepool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_count     = 2
  node_pool_name = "database-nodepool"
  product_code   = data.ncloud_nks_server_products.service_servers.products[0].value
  software_code = data.ncloud_nks_server_images.server_image.images[0].value
  subnet_no_list = [ncloud_subnet.kubernetes_subnet.id]
  autoscale {
    enabled = true
    max     = 5
    min     = 2
  }
}
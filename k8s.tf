
variable "cluster_name" {
  type = string
  default = "k8sy-perry"
}

variable "external_network_name" {
  type = string
  default = "ilab-215"
}

variable "keypair_name" {
  type = string
  default = "will"
}

provider "openstack" {
  cloud = "default"
}

resource "openstack_networking_network_v2" "cluster_network" {
  name = "k8s-network-${var.cluster_name}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "cluster_subnet" {
  network_id = "${openstack_networking_network_v2.cluster_network.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
}

data "openstack_networking_network_v2" "external_network" {
 name = "${var.external_network_name}"
}

data "openstack_networking_subnet_v2" "cumulus_internal_subnet" {
  name = "cumulus-internal"
  #subnet_id = "01b76c7c-3c1a-4c5c-9a5a-14bcf6c0c290"
}

data "openstack_networking_subnet_v2" "cumulus_storage_subnet" {
  name = "cumulus-storage"
}

resource "openstack_networking_router_v2" "cluster_router" {
  name = "k8s-router-${var.cluster_name}"
  external_network_id = "${data.openstack_networking_network_v2.external_network.id}"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.cluster_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.cluster_subnet.id}"
}

# resource "openstack_networking_router_interface_v2" "router_interface_2" {
#   router_id = "${openstack_networking_router_v2.cluster_router.id}"
#   subnet_id = "{data.openstack_networking_subnet_v2.cumulus_internal_subnet.id}"
# }

# alternatively, add the cumulus_storage subnet to the router, but we'd need to
# adjust the return route on the storage nodes
resource "openstack_networking_router_route_v2" "router_route_1" {
  depends_on       = ["openstack_networking_router_interface_v2.router_interface_1"]
  router_id        = "${openstack_networking_router_v2.cluster_router.id}"
  destination_cidr = "10.206.0.0/16"
  next_hop         = "10.215.0.3"
}

resource "openstack_containerinfra_clustertemplate_v1" "kubernetes_template" {
  name                  = "k8s-1.1.4.3-1"
  image                 = "FedoraAtomic29-20190429"
  coe                   = "kubernetes"
  docker_volume_size    = 100
  volume_driver         = "cinder"
  flavor                = "general.v1.small"
  master_flavor         = "general.v1.tiny"
  docker_storage_driver = "overlay2"
  network_driver        = "flannel"
  server_type           = "vm"
  external_network_id   = "${var.external_network_name}"
  master_lb_enabled     = false
  public                = true
  floating_ip_enabled   = false
  dns_nameserver        = "8.8.8.8"
  fixed_network         = "${openstack_networking_network_v2.cluster_network.id}"
  fixed_subnet          = "${openstack_networking_subnet_v2.cluster_subnet.id}"
  labels = {
    cgroup_driver="cgroupfs"
    prometheus_monitoring="true"
    kube_tag="v1.14.3"
    cloud_provider_tag="v1.14.0"
    docker_volume_type="rbd"
  }
}

resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                 = "${var.cluster_name}"
  cluster_template_id  = "${openstack_containerinfra_clustertemplate_v1.kubernetes_template.id}"
  master_count         = 1
  node_count           = 1
  keypair              = "${var.keypair_name}"
}


resource "openstack_compute_instance_v2" "cluster_login" {
  name            = "k8s-login-${var.cluster_name}"
  image_name      = "CentOS7-1901"
  flavor_name     = "general.v1.tiny"
  key_pair        = "${var.keypair_name}"
  security_groups = ["default"]
  config_drive = true

  network {
    uuid = "${openstack_networking_network_v2.cluster_network.id}"
  }

  network {
    name = "cumulus-internal"
  }
}

# data "openstack_networking_floatingip_v2" "floatingip_1" {
#   address = "128.232.224.70"
# }

resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip = "128.232.224.70"
  instance_id = "${openstack_compute_instance_v2.cluster_login.id}"
  fixed_ip    = "${openstack_compute_instance_v2.cluster_login.network.1.fixed_ip_v4}"
}

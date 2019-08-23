
variable "cluster_name" {
  type = string
  default = "k8sy-perry"
}

variable "external_network_name" {
  type = string
  default = "provision-net"
}

variable "fixed_network_name" {
  type = string
  default = "provision-net"
}

variable "fixed_subnet_name" {
  type = string
  default = "provision-net"
}

variable "keypair_name" {
  type = string
  default = "default"
}

provider "openstack" {
  cloud = "eiffel"
}

resource "openstack_containerinfra_clustertemplate_v1" "kubernetes_template" {
  name                  = "k8s"
  image                 = "FedoraAtomic29-20190708"
  coe                   = "kubernetes"
  flavor                = "C6420-Xeon6148-192"
  master_flavor         = "C6420-Xeon6148-192"
  docker_storage_driver = "overlay2"
  network_driver        = "flannel"
  server_type           = "vm"
  external_network_id   = "${var.external_network_name}"
  fixed_network         = "${var.fixed_network_name}"
  fixed_subnet          = "${var.fixed_subnet_name}"
  master_lb_enabled     = false
  public                = true
  floating_ip_enabled   = false
  labels = {
    cgroup_driver="cgroupfs"
    ingress_controller="traefik"
    prometheus_monitoring="true"
    kube_tag="v1.14.5"
    cloud_provider_tag="v1.14.0"
    heat_container_agent_tag="stein-stable"

  }
}

resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                 = "${var.cluster_name}"
  cluster_template_id  = "${openstack_containerinfra_clustertemplate_v1.kubernetes_template.id}"
  master_count         = 1
  node_count           = 3
  keypair              = "${var.keypair_name}"
}
